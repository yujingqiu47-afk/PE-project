package controller;

import dao.DestinationDAO;
import dao.PackageDAO;
import model.Destination;
import model.Package;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/destinations")
public class DestinationServlet extends HttpServlet {
    private DestinationDAO destinationDAO;
    private PackageDAO packageDAO;

    @Override
    public void init() throws ServletException {
        destinationDAO = new DestinationDAO();
        packageDAO = new PackageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("packages".equals(action)) {
            showPackages(request, response);
        } else {
            showDestinations(request, response);
        }
    }

    private void showDestinations(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 获取分页参数
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            
            int currentPage = 1;
            int pageSize = 9; // 默认每页显示9个目的地（3x3网格）
            
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
                    if (pageSize < 6) {
                        pageSize = 6;
                    } else if (pageSize > 24) {
                        pageSize = 24;
                    }
                } catch (NumberFormatException e) {
                    pageSize = 9;
                }
            }
            
            // 获取分页数据
            List<Destination> destinations = destinationDAO.getDestinationsWithPagination(currentPage, pageSize);
            int totalCount = destinationDAO.getTotalActiveDestinationCount();
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
            
            request.getRequestDispatcher("/destinations.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // 如果出错，返回所有目的地
            List<Destination> destinations = destinationDAO.getAllDestinations();
            request.setAttribute("destinations", destinations);
            request.getRequestDispatcher("/destinations.jsp").forward(request, response);
        }
    }

    private void showPackages(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String destinationIdStr = request.getParameter("destinationId");
        if (destinationIdStr != null) {
            try {
                int destinationId = Integer.parseInt(destinationIdStr);
                Destination destination = destinationDAO.getDestinationById(destinationId);
                List<Package> packages = packageDAO.getPackagesByDestination(destinationId);
                
                request.setAttribute("destination", destination);
                request.setAttribute("packages", packages);
                request.getRequestDispatcher("/packages.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect("destinations");
            }
        } else {
            response.sendRedirect("destinations");
        }
    }
}
