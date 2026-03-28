package controller;

import dao.BookingDAO;
import dao.DestinationDAO;
import dao.PackageDAO;
import model.Booking;
import model.Destination;
import model.Package;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet({"/admin/", "/admin/destinations", "/admin/packages", "/admin/bookings"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 5,      // 5 MB
    maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class AdminServlet extends HttpServlet {
    private DestinationDAO destinationDAO;
    private PackageDAO packageDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
        packageDAO = new PackageDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户是否已登录且是管理员
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || !"admin".equals(role)) {
            response.sendRedirect("../login.jsp?error=您需要管理员权限才能访问此页面");
            return;
        }

        // 根据请求路径决定显示哪个页面
        String servletPath = request.getServletPath();
        
        if (servletPath.equals("/admin/") || servletPath.equals("/admin")) {
            showAdminDashboard(request, response);
        } else if (servletPath.equals("/admin/destinations")) {
            showDestinationManagement(request, response);
        } else if (servletPath.equals("/admin/packages")) {
            showPackageManagement(request, response);
        } else if (servletPath.equals("/admin/bookings")) {
            showBookingManagement(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户是否已登录且是管理员
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || !"admin".equals(role)) {
            response.sendRedirect("../login.jsp?error=您需要管理员权限才能访问此页面");
            return;
        }

        String servletPath = request.getServletPath();
        String action = request.getParameter("action");

        if (servletPath.equals("/admin/destinations")) {
            handleDestinationAction(request, response, action);
        } else if (servletPath.equals("/admin/packages")) {
            handlePackageAction(request, response, action);
        } else if (servletPath.equals("/admin/bookings")) {
            handleBookingAction(request, response, action);
        }
    }

    private void showAdminDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 初始化空列表
            List<Destination> destinations = new ArrayList<>();
            List<Package> packages = new ArrayList<>();
            List<Booking> recentBookings = new ArrayList<>();

            // 尝试获取数据
            try {
                destinations = destinationDAO.getAllDestinationsForAdmin();
                packages = packageDAO.getAllPackagesForAdmin();
                recentBookings = bookingDAO.getAllBookings();
            } catch (Exception e) {
                // 忽略数据库错误，使用空列表
            }

            // 设置数据
            request.setAttribute("destinations", destinations);
            request.setAttribute("packages", packages);
            request.setAttribute("bookings", recentBookings);

            // 转发到dashboard.jsp
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "管理员控制台加载失败: " + e.getMessage());
        }
    }

    private void showDestinationManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 获取分页参数
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            
            int currentPage = 1;
            int pageSize = 10; // 默认每页显示10条记录
            
            // 解析页码参数
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // 解析每页大小参数
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 5) {
                        pageSize = 5;
                    } else if (pageSize > 50) {
                        pageSize = 50;
                    }
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }
            
            // 获取分页数据
            List<Destination> destinations = destinationDAO.getDestinationsForAdminWithPagination(currentPage, pageSize);
            int totalCount = destinationDAO.getTotalDestinationCount();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // 设置分页相关属性
            request.setAttribute("destinations", destinations);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            
            // 计算分页显示范围
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            
            request.getRequestDispatcher("/admin/destinations.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "加载目的地管理失败: " + e.getMessage());
        }
    }

    private void showPackageManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 获取分页参数
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            
            int currentPage = 1;
            int pageSize = 10; // 默认每页显示10条记录
            
            // 解析页码参数
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // 解析每页大小参数
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 5) {
                        pageSize = 5;
                    } else if (pageSize > 50) {
                        pageSize = 50;
                    }
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }
            
            // 获取分页数据
            List<Package> packages = packageDAO.getPackagesForAdminWithPagination(currentPage, pageSize);
            List<Destination> destinations = destinationDAO.getAllDestinationsForAdmin();
            int totalCount = packageDAO.getTotalPackageCount();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // 设置分页相关属性
            request.setAttribute("packages", packages);
            request.setAttribute("destinations", destinations);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            
            // 计算分页显示范围
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            
            request.getRequestDispatcher("/admin/packages.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "加载套餐管理失败: " + e.getMessage());
        }
    }

    private void showBookingManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 获取分页参数
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            
            int currentPage = 1;
            int pageSize = 10; // 默认每页显示10条记录
            
            // 解析页码参数
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // 解析每页大小参数
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 5) {
                        pageSize = 5;
                    } else if (pageSize > 50) {
                        pageSize = 50;
                    }
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }
            
            // 获取分页数据
            List<Booking> bookings = bookingDAO.getAllBookingsWithPagination(currentPage, pageSize);
            List<Destination> destinations = destinationDAO.getAllDestinationsForAdmin();
            List<Package> packages = packageDAO.getAllPackagesForAdmin();
            int totalCount = bookingDAO.getTotalBookingCount();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // 获取统计数据
            int pendingCount = bookingDAO.getBookingCountByStatus("pending");
            int confirmedCount = bookingDAO.getBookingCountByStatus("confirmed");
            double totalRevenue = bookingDAO.getTotalRevenue();
            
            // 设置分页相关属性
            request.setAttribute("bookings", bookings);
            request.setAttribute("destinations", destinations);
            request.setAttribute("packages", packages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("totalPages", totalPages);
            
            // 设置统计数据
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("confirmedCount", confirmedCount);
            request.setAttribute("totalRevenue", totalRevenue);
            
            // 计算分页显示范围
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            
            request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "加载预订管理失败: " + e.getMessage());
        }
    }

    private void handleDestinationAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {

        try {
            if ("create".equals(action)) {
                // 创建新目的地
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                
                // 处理文件上传
                String imageName = handleImageUpload(request, "imageFile");
                if (imageName == null) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "请选择一个有效的图片文件");
                    return;
                }

                Destination destination = new Destination();
                destination.setName(name);
                destination.setDescription(description);
                destination.setImage(imageName);
                destination.setActive(true);

                destinationDAO.createDestination(destination);

            } else if ("update".equals(action)) {
                // 更新目的地
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String oldImage = request.getParameter("oldImage");
                boolean isActive = "true".equals(request.getParameter("isActive"));

                // 处理文件上传（如果有新文件）
                String imageName = handleImageUpload(request, "imageFile");
                if (imageName == null) {
                    // 没有上传新文件，使用原有图片
                    imageName = oldImage;
                } else {
                    // 上传了新文件，删除旧文件
                    deleteOldImage(oldImage);
                }

                Destination destination = new Destination();
                destination.setId(id);
                destination.setName(name);
                destination.setDescription(description);
                destination.setImage(imageName);
                destination.setActive(isActive);

                destinationDAO.updateDestination(destination);

            } else if ("delete".equals(action)) {
                // 删除目的地
                int id = Integer.parseInt(request.getParameter("id"));
                
                // 获取要删除的目的地信息，以便删除其图片文件
                Destination destination = destinationDAO.getDestinationById(id);
                if (destination != null && destination.getImage() != null) {
                    deleteOldImage(destination.getImage());
                }
                
                destinationDAO.deleteDestination(id);
            }

            response.sendRedirect("destinations");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "处理目的地操作失败: " + e.getMessage());
        }
    }
    
    /**
     * 处理图片上传
     * @param request HTTP请求
     * @param partName 文件part名称
     * @return 上传成功后的文件名，失败返回null
     */
    private String handleImageUpload(HttpServletRequest request, String partName) throws IOException, ServletException {
        Part filePart = request.getPart(partName);
        
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        // 获取原始文件名
        String originalFileName = getFileName(filePart);
        if (originalFileName == null || originalFileName.isEmpty()) {
            return null;
        }
        
        // 检查文件类型
        String contentType = filePart.getContentType();
        if (!isValidImageType(contentType)) {
            throw new ServletException("不支持的文件类型: " + contentType);
        }
        
        // 获取文件扩展名
        String fileExtension = getFileExtension(originalFileName);
        
        // 生成新的文件名（使用UUID避免重名）
        String newFileName = UUID.randomUUID().toString() + fileExtension;
        
        // 获取上传目录路径
        String uploadPath = getUploadPath(request);
        
        // 确保上传目录存在
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // 保存文件
        Path filePath = Paths.get(uploadPath, newFileName);
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
        }
        
        return newFileName;
    }
    
    /**
     * 获取上传目录路径
     */
    private String getUploadPath(HttpServletRequest request) {
        // 获取webapp目录下的images/Pictures路径
        String webappPath = request.getServletContext().getRealPath("");
        return webappPath + File.separator + "images" + File.separator + "Pictures";
    }
    
    /**
     * 从Part中获取文件名
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
    
    /**
     * 检查是否是有效的图片类型
     */
    private boolean isValidImageType(String contentType) {
        return contentType != null && (
            contentType.equals("image/jpeg") ||
            contentType.equals("image/jpg") ||
            contentType.equals("image/png") ||
            contentType.equals("image/gif")
        );
    }
    
    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex);
        }
        return ".jpg"; // 默认扩展名
    }
    
    /**
     * 删除旧图片文件
     */
    private void deleteOldImage(String imageName) {
        if (imageName == null || imageName.isEmpty()) {
            return;
        }
        
        try {
            // 获取webapp目录下的images/Pictures路径
            String webappPath = getServletContext().getRealPath("");
            String imagePath = webappPath + File.separator + "images" + File.separator + "Pictures" + File.separator + imageName;
            
            File imageFile = new File(imagePath);
            if (imageFile.exists()) {
                imageFile.delete();
            }
        } catch (Exception e) {
            // 删除文件失败不影响主要功能，只记录日志
            System.err.println("删除旧图片文件失败: " + imageName + ", 错误: " + e.getMessage());
        }
    }

    private void handlePackageAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {

        try {
            if ("create".equals(action)) {
                // 创建新套餐
                int destinationId = Integer.parseInt(request.getParameter("destinationId"));
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String price = request.getParameter("price");
                String features = request.getParameter("features");

                Package pkg = new Package();
                pkg.setDestinationId(destinationId);
                pkg.setName(name);
                pkg.setDescription(description);
                pkg.setPrice(new java.math.BigDecimal(price));
                pkg.setFeatures(features);
                pkg.setActive(true);

                packageDAO.createPackage(pkg);

            } else if ("update".equals(action)) {
                // 更新套餐
                int id = Integer.parseInt(request.getParameter("id"));
                int destinationId = Integer.parseInt(request.getParameter("destinationId"));
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String price = request.getParameter("price");
                String features = request.getParameter("features");
                boolean isActive = "true".equals(request.getParameter("isActive"));

                Package pkg = new Package();
                pkg.setId(id);
                pkg.setDestinationId(destinationId);
                pkg.setName(name);
                pkg.setDescription(description);
                pkg.setPrice(new java.math.BigDecimal(price));
                pkg.setFeatures(features);
                pkg.setActive(isActive);

                packageDAO.updatePackage(pkg);

            } else if ("delete".equals(action)) {
                // 删除套餐
                int id = Integer.parseInt(request.getParameter("id"));
                packageDAO.deletePackage(id);
            }

            response.sendRedirect("packages");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "处理套餐操作失败: " + e.getMessage());
        }
    }

    private void handleBookingAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {

        try {
            if ("updateStatus".equals(action)) {
                // 更新预订状态
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String status = request.getParameter("status");

                bookingDAO.updateBookingStatus(bookingId, status);
            }

            response.sendRedirect("bookings");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "处理预订操作失败: " + e.getMessage());
        }
    }
}
