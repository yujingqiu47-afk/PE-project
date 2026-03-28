/*
 Navicat Premium Dump SQL

 Source Server         : 本地Mysql
 Source Server Type    : MySQL
 Source Server Version : 80019 (8.0.19)
 Source Host           : localhost:3307
 Source Schema         : travel_db

 Target Server Type    : MySQL
 Target Server Version : 80019 (8.0.19)
 File Encoding         : 65001

 Date: 01/07/2025 09:38:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for bookings
-- ----------------------------
DROP TABLE IF EXISTS `bookings`;
CREATE TABLE `bookings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `customer_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `customer_email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `customer_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `destination_id` int NOT NULL,
  `package_id` int NOT NULL,
  `payment_method` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payment_info` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `destination_id` (`destination_id`),
  KEY `package_id` (`package_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`) ON DELETE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`),
  CONSTRAINT `bookings_ibfk_3` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of bookings
-- ----------------------------
BEGIN;
INSERT INTO `bookings` (`id`, `username`, `customer_name`, `customer_email`, `customer_phone`, `destination_id`, `package_id`, `payment_method`, `payment_info`, `total_amount`, `booking_date`, `status`) VALUES (1, 'zszs', 'zszs', '123@113.com', '18500000000', 4, 10, 'alipay', '18500000000', 259.00, '2025-06-30 12:48:56', 'completed');
INSERT INTO `bookings` (`id`, `username`, `customer_name`, `customer_email`, `customer_phone`, `destination_id`, `package_id`, `payment_method`, `payment_info`, `total_amount`, `booking_date`, `status`) VALUES (2, 'zszs', 'zszs', '123@113.com', '18500000000', 3, 8, 'alipay', '18500000000', 699.00, '2025-07-01 01:18:55', 'pending');
COMMIT;

-- ----------------------------
-- Table structure for destinations
-- ----------------------------
DROP TABLE IF EXISTS `destinations`;
CREATE TABLE `destinations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `image` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of destinations
-- ----------------------------
BEGIN;
INSERT INTO `destinations` (`id`, `name`, `description`, `image`, `is_active`, `created_at`) VALUES (1, '海洋水族馆', '探索神秘的海洋世界，与海洋生物亲密接触', 'Aquarium.png', 1, '2025-06-30 06:09:48');
INSERT INTO `destinations` (`id`, `name`, `description`, `image`, `is_active`, `created_at`) VALUES (2, '蜜蜂农场', '体验田园生活，了解蜜蜂的世界', 'Buzzy bees.png', 1, '2025-06-30 06:09:48');
INSERT INTO `destinations` (`id`, `name`, `description`, `image`, `is_active`, `created_at`) VALUES (3, '科技体验馆', '感受前沿科技的魅力', 'Dimension.png', 1, '2025-06-30 06:09:48');
INSERT INTO `destinations` (`id`, `name`, `description`, `image`, `is_active`, `created_at`) VALUES (4, '自然探索之旅', '深入大自然，探索未知的奥秘。', 'Exploration.png', 1, '2025-06-30 06:09:48');
INSERT INTO `destinations` (`id`, `name`, `description`, `image`, `is_active`, `created_at`) VALUES (6, '测试', '测试', '474de9f6-296f-4b3d-8bdf-9669c10a87e0.png', 1, '2025-06-30 09:42:15');
COMMIT;

-- ----------------------------
-- Table structure for feedback
-- ----------------------------
DROP TABLE IF EXISTS `feedback`;
CREATE TABLE `feedback` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '客户姓名',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '邮箱地址',
  `overall_rating` tinyint NOT NULL COMMENT '整体满意度评分(1-5星)',
  `feedback_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '反馈类型',
  `detailed_feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '详细反馈内容',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话(可选)',
  `allow_contact` tinyint(1) DEFAULT '0' COMMENT '是否同意旅行社就此反馈与我联系(0:否,1:是)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '反馈提交时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  KEY `created_at` (`created_at`),
  CONSTRAINT `chk_overall_rating` CHECK (((`overall_rating` >= 1) and (`overall_rating` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='客户反馈表';

-- ----------------------------
-- Records of feedback
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for packages
-- ----------------------------
DROP TABLE IF EXISTS `packages`;
CREATE TABLE `packages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination_id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `price` decimal(10,2) NOT NULL,
  `features` text COLLATE utf8mb4_general_ci,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `packages_ibfk_1` FOREIGN KEY (`destination_id`) REFERENCES `destinations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of packages
-- ----------------------------
BEGIN;
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (1, 1, '基础套餐A', '包含水族馆门票和基础讲解服务', 299.00, '水族馆门票;基础讲解;纪念品', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (2, 1, '标准套餐B', '包含门票、专业讲解和海豚表演', 499.00, '水族馆门票;专业讲解;海豚表演;午餐;纪念品', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (3, 1, '豪华套餐C', '全方位海洋体验，包含潜水体验', 799.00, '水族馆门票;专业讲解;海豚表演;潜水体验;豪华午餐;精美纪念品;专车接送', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (4, 2, '基础套餐A', '参观蜜蜂农场，了解蜜蜂生活', 199.00, '农场参观;蜜蜂知识讲解;蜂蜜试吃', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (5, 2, '标准套餐B', '深度体验养蜂过程', 349.00, '农场参观;养蜂体验;蜂蜜制作;农家午餐;蜂蜜礼盒', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (6, 2, '豪华套餐C', '完整的田园生活体验', 599.00, '农场参观;养蜂体验;蜂蜜制作;有机农业体验;农家午餐;蜂蜜礼盒;专车接送', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (7, 3, '基础套餐A', 'VR体验和基础科技展览', 399.00, 'VR体验;科技展览;基础讲解', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (8, 3, '标准套餐B', '互动科技体验', 699.00, 'VR体验;科技展览;互动体验;科技讲座;纪念品', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (9, 3, '豪华套餐C', '全方位科技探索', 999.00, 'VR体验;科技展览;互动体验;科技讲座;机器人互动;豪华午餐;科技纪念品;专车接送', 0, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (10, 4, '基础套餐A', '自然徒步和基础观察', 259.00, '自然徒步;动植物观察;基础讲解', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (11, 4, '标准套餐B', '深度自然探索', 459.00, '自然徒步;动植物观察;专业讲解;野外午餐;观鸟体验', 1, '2025-06-30 06:09:48');
INSERT INTO `packages` (`id`, `destination_id`, `name`, `description`, `price`, `features`, `is_active`, `created_at`) VALUES (12, 4, '豪华套餐C', '完整的自然探险', 759.00, '自然徒步;动植物观察;专业讲解;野外午餐;观鸟体验;夜间观星;露营体验;专车接送', 1, '2025-06-30 06:09:48');
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('user','admin') COLLATE utf8mb4_general_ci DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` (`username`, `password`, `email`, `role`, `created_at`) VALUES ('admin', 'admin123', 'admin@travel.com', 'admin', '2025-06-30 06:09:48');
INSERT INTO `users` (`username`, `password`, `email`, `role`, `created_at`) VALUES ('zszs', '123456', '123@113.com', 'user', '2025-06-30 12:27:22');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
