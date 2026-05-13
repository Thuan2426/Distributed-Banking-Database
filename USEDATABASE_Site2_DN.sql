-- =========================================================================
-- ĐỒ ÁN HỆ QUẢN TRỊ CSDL NÂNG CAO - TECHCOMBANK
-- SCRIPT: USEDATABASE_Site2_DN.sql (CHI NHÁNH ĐÀ NẴNG)
-- =========================================================================

-- 1. TẠO DATABASE
CREATE DATABASE Techcombank_Site2_DN;
GO
USE Techcombank_Site2_DN;
GO

-- =========================================================================
-- 2. TẠO CẤU TRÚC 16 BẢNG (CHUẨN 100% THEO GLOBAL)
-- Đã sắp xếp thứ tự tạo bảng để không lỗi Khóa Ngoại
-- =========================================================================

-- Bảng danh mục độc lập
CREATE TABLE CHINHANH (idChi_Nhanh VARCHAR(20) PRIMARY KEY, nameCN NVARCHAR(100) NOT NULL, addressCN NVARCHAR(255) NOT NULL, FAX_CN VARCHAR(20));
CREATE TABLE PHONGBAN (idPhong_Ban VARCHAR(20) PRIMARY KEY, namePB NVARCHAR(100) NOT NULL, scalePB INT, organizationPB NVARCHAR(255));
CREATE TABLE LAISUAT (idLai_Suat VARCHAR(20) PRIMARY KEY, rateLS DECIMAL(5,2) NOT NULL, descriptionLS NVARCHAR(255));
CREATE TABLE KHACHHANG (idKH VARCHAR(20) PRIMARY KEY, nameKH NVARCHAR(100) NOT NULL, addressKH NVARCHAR(255), numberKH VARCHAR(15), emailKH VARCHAR(100), genderKH NVARCHAR(10), jobKH NVARCHAR(100));

-- Bảng phụ thuộc cấp 1
CREATE TABLE NHANVIEN (idNhan_Vien VARCHAR(20) PRIMARY KEY, nameNV NVARCHAR(100) NOT NULL, addressNV NVARCHAR(255), numberNV VARCHAR(15) UNIQUE NOT NULL, emailNV VARCHAR(100) UNIQUE, titleNV NVARCHAR(50), idPhong_Ban VARCHAR(20), FOREIGN KEY (idPhong_Ban) REFERENCES PHONGBAN(idPhong_Ban));
CREATE TABLE LOAI_HOPDONG (idLoaiHop_Dong VARCHAR(20) PRIMARY KEY, nameLoaiHD NVARCHAR(100) NOT NULL, termHD INT, idLai_Suat VARCHAR(20), FOREIGN KEY (idLai_Suat) REFERENCES LAISUAT(idLai_Suat));
CREATE TABLE TAIKHOAN (idTai_Khoan VARCHAR(20) PRIMARY KEY, numTK VARCHAR(20) UNIQUE NOT NULL, typeTK NVARCHAR(50), dateTK DATETIME DEFAULT GETDATE(), balanceTK DECIMAL(18,2) DEFAULT 0, idKH VARCHAR(20), FOREIGN KEY (idKH) REFERENCES KHACHHANG(idKH));

-- Bảng phụ thuộc cấp 2 (Nghiệp vụ cốt lõi)
CREATE TABLE HOPDONG (idHop_Dong VARCHAR(20) PRIMARY KEY, dateHD DATETIME DEFAULT GETDATE(), borrowHD DECIMAL(18,2) NOT NULL, remainHD DECIMAL(18,2), statusHD NVARCHAR(50), idKH VARCHAR(20), idLoaiHop_Dong VARCHAR(20), idNhan_Vien VARCHAR(20), FOREIGN KEY (idKH) REFERENCES KHACHHANG(idKH), FOREIGN KEY (idLoaiHop_Dong) REFERENCES LOAI_HOPDONG(idLoaiHop_Dong), FOREIGN KEY (idNhan_Vien) REFERENCES NHANVIEN(idNhan_Vien));
CREATE TABLE GIAODICH_TINDUNG (idGD VARCHAR(50) PRIMARY KEY, timeGD DATETIME DEFAULT GETDATE(), typeGD NVARCHAR(50), numGD DECIMAL(18,2) NOT NULL, feeGD DECIMAL(18,2) DEFAULT 0, discountGD DECIMAL(18,2) DEFAULT 0, statusGD NVARCHAR(50), idNhan_Vien VARCHAR(20), idTai_Khoan VARCHAR(20), FOREIGN KEY (idNhan_Vien) REFERENCES NHANVIEN(idNhan_Vien), FOREIGN KEY (idTai_Khoan) REFERENCES TAIKHOAN(idTai_Khoan));

-- Bảng nghiệp vụ chứng từ và kho quỹ (Hoàn thiện đủ 16 bảng)
CREATE TABLE PHIEU_THONGBAO (idThong_Bao VARCHAR(20) PRIMARY KEY, numThong_Bao INT, timeThong_Bao DATETIME DEFAULT GETDATE(), idKH VARCHAR(20), FOREIGN KEY (idKH) REFERENCES KHACHHANG(idKH));
CREATE TABLE PHIEU_THANHTOAN (idThanh_Toan VARCHAR(20) PRIMARY KEY, numTT DECIMAL(18,2) NOT NULL, timeTT DATETIME DEFAULT GETDATE(), idKH VARCHAR(20), FOREIGN KEY (idKH) REFERENCES KHACHHANG(idKH));
CREATE TABLE PHIEU_NHANTIEN (idNhan_Tien VARCHAR(20) PRIMARY KEY, numNT DECIMAL(18,2) NOT NULL, timeNT DATETIME DEFAULT GETDATE(), idKH VARCHAR(20), FOREIGN KEY (idKH) REFERENCES KHACHHANG(idKH));
CREATE TABLE PHIEU_DENHGHI (idDe_Nghi VARCHAR(20) PRIMARY KEY, numDN DECIMAL(18,2) NOT NULL, timeDN DATETIME DEFAULT GETDATE(), idNhan_Vien VARCHAR(20), FOREIGN KEY (idNhan_Vien) REFERENCES NHANVIEN(idNhan_Vien));
CREATE TABLE PHIEU_CHUYENKHOAN (idChuyen_Khoan VARCHAR(20) PRIMARY KEY, numCK DECIMAL(18,2) NOT NULL, timeCK DATETIME DEFAULT GETDATE(), idChi_Nhanh VARCHAR(20), FOREIGN KEY (idChi_Nhanh) REFERENCES CHINHANH(idChi_Nhanh));
CREATE TABLE PHIEU_XUATKHO (idXuat_Kho VARCHAR(20) PRIMARY KEY, numXK DECIMAL(18,2) NOT NULL, timeXK DATETIME DEFAULT GETDATE(), idNhan_Vien VARCHAR(20), FOREIGN KEY (idNhan_Vien) REFERENCES NHANVIEN(idNhan_Vien));
CREATE TABLE KHO_QUY (idKho_Quy VARCHAR(20) PRIMARY KEY, reserve_fund DECIMAL(18,2) NOT NULL, timeKQ DATETIME DEFAULT GETDATE(), idChi_Nhanh VARCHAR(20), idDe_Nghi VARCHAR(20), idChuyen_Khoan VARCHAR(20), FOREIGN KEY (idChi_Nhanh) REFERENCES CHINHANH(idChi_Nhanh), FOREIGN KEY (idDe_Nghi) REFERENCES PHIEU_DENHGHI(idDe_Nghi), FOREIGN KEY (idChuyen_Khoan) REFERENCES PHIEU_CHUYENKHOAN(idChuyen_Khoan));

-- =========================================================================
-- 3. INSERT DỮ LIỆU ĐỊA PHƯƠNG (SITE ĐÀ NẴNG)
-- =========================================================================

-- [CHINHANH & PHONGBAN]
INSERT INTO CHINHANH VALUES ('CN_DN', N'Techcombank CN Đà Nẵng', N'97 Nguyễn Văn Linh, Hải Châu, Đà Nẵng', '0236.3123.456');
INSERT INTO PHONGBAN VALUES 
('PB_TD_DN', N'Phòng Tín Dụng Cá Nhân', 20, N'Khối Bán Lẻ'),
('PB_DN_DN', N'Phòng Tín Dụng Doanh Nghiệp', 15, N'Khối KHDN'),
('PB_CS_DN', N'Phòng Dịch Vụ Khách Hàng', 25, N'Khối Vận Hành'),
('PB_KT_DN', N'Phòng Kế Toán - Kho Quỹ', 10, N'Khối Nguồn Vốn');

-- [NHANVIEN] - 15 Nhân viên tại Đà Nẵng
INSERT INTO NHANVIEN VALUES 
('NV_DN01', N'Võ Văn Kiệt', N'Hải Châu, Đà Nẵng', '0912110001', 'kiet.vv@techcombank.vn', N'Giám đốc Chi nhánh', 'PB_TD_DN'),
('NV_DN02', N'Huỳnh Thị Sáu', N'Thanh Khê, Đà Nẵng', '0912110002', 'sau.ht@techcombank.vn', N'Trưởng phòng', 'PB_TD_DN'),
('NV_DN03', N'Phan Châu Trinh', N'Sơn Trà, Đà Nẵng', '0912110003', 'trinh.pc@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_DN'),
('NV_DN04', N'Lê Đình Lý', N'Ngũ Hành Sơn, Đà Nẵng', '0912110004', 'ly.ld@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_DN'),
('NV_DN05', N'Nguyễn Bá Lân', N'Cẩm Lệ, Đà Nẵng', '0912110005', 'lan.nb@techcombank.vn', N'Chuyên viên KHDN', 'PB_DN_DN'),
('NV_DN06', N'Trương Mỹ Hoa', N'Hòa Vang, Đà Nẵng', '0912110006', 'hoa.tm@techcombank.vn', N'Chuyên viên KHDN', 'PB_DN_DN'),
('NV_DN07', N'Đinh Công Trừng', N'Liên Chiểu, Đà Nẵng', '0912110007', 'trung.dc@techcombank.vn', N'Giao dịch viên', 'PB_CS_DN'),
('NV_DN08', N'Võ Nguyên Giáp', N'Hải Châu, Đà Nẵng', '0912110008', 'giap.vn@techcombank.vn', N'Giao dịch viên', 'PB_CS_DN'),
('NV_DN09', N'Trần Cao Vân', N'Thanh Khê, Đà Nẵng', '0912110009', 'van.tc@techcombank.vn', N'Giao dịch viên', 'PB_CS_DN'),
('NV_DN10', N'Lý Tự Trọng', N'Sơn Trà, Đà Nẵng', '0912110010', 'trong.lt@techcombank.vn', N'Giao dịch viên', 'PB_CS_DN'),
('NV_DN11', N'Mai Hắc Đế', N'Ngũ Hành Sơn, Đà Nẵng', '0912110011', 'de.mh@techcombank.vn', N'Giao dịch viên', 'PB_CS_DN'),
('NV_DN12', N'Bùi Xuân Phái', N'Cẩm Lệ, Đà Nẵng', '0912110012', 'phai.bx@techcombank.vn', N'Kế toán trưởng', 'PB_KT_DN'),
('NV_DN13', N'Phạm Phú Thứ', N'Liên Chiểu, Đà Nẵng', '0912110013', 'thu.pp@techcombank.vn', N'Kiểm soát viên', 'PB_KT_DN'),
('NV_DN14', N'Hoàng Diệu', N'Hòa Vang, Đà Nẵng', '0912110014', 'dieu.h@techcombank.vn', N'Thủ quỹ', 'PB_KT_DN'),
('NV_DN15', N'Ngô Quyền', N'Hải Châu, Đà Nẵng', '0912110015', 'quyen.n@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_DN');

-- [KHACHHANG] - 40 Khách hàng (100% địa chỉ chứa 'Đà Nẵng')
INSERT INTO KHACHHANG VALUES 
('KH_DN001', N'Phan Văn Khải', N'Số 10 Nguyễn Văn Linh, Hải Châu, Đà Nẵng', '0935220001', 'khaiphan@gmail.com', N'Nam', N'Kinh doanh'),
('KH_DN002', N'Nguyễn Thị Định', N'KĐT Hòa Xuân, Cẩm Lệ, Đà Nẵng', '0935220002', 'dinhnguyen@gmail.com', N'Nữ', N'Bác sĩ'),
('KH_DN003', N'Võ Văn Tần', N'Đường 2/9, Hải Châu, Đà Nẵng', '0935220003', 'tanvo@gmail.com', N'Nam', N'Kỹ sư'),
('KH_DN004', N'Huỳnh Thúc Kháng', N'Phạm Văn Đồng, Sơn Trà, Đà Nẵng', '0935220004', 'khanghuynh@gmail.com', N'Nam', N'Kiến trúc sư'),
('KH_DN005', N'Lê Duẩn', N'Nguyễn Tất Thành, Thanh Khê, Đà Nẵng', '0935220005', 'duanle@gmail.com', N'Nam', N'Giám đốc'),
('KH_DN006', N'Trần Phú', N'Tôn Đức Thắng, Liên Chiểu, Đà Nẵng', '0935220006', 'phutran@gmail.com', N'Nam', N'Kế toán'),
('KH_DN007', N'Hồ Nghinh', N'Quốc lộ 14B, Hòa Vang, Đà Nẵng', '0935220007', 'nghinhho@gmail.com', N'Nam', N'Chủ trang trại'),
('KH_DN008', N'Ngô Gia Tự', N'Lê Văn Hiến, Ngũ Hành Sơn, Đà Nẵng', '0935220008', 'tungo@gmail.com', N'Nam', N'Nhà thầu xây dựng'),
('KH_DN009', N'Đặng Thai Mai', N'Hùng Vương, Hải Châu, Đà Nẵng', '0935220009', 'maidang@gmail.com', N'Nữ', N'Giáo viên'),
('KH_DN010', N'Hoàng Hoa Thám', N'Điện Biên Phủ, Thanh Khê, Đà Nẵng', '0935220010', 'thamhoang@gmail.com', N'Nam', N'Lập trình viên'),
('KH_DN011', N'Lý Thái Tổ', N'Trần Hưng Đạo, Sơn Trà, Đà Nẵng', '0935220011', 'toly@gmail.com', N'Nam', N'Nhân viên VP'),
('KH_DN012', N'Trương Định', N'Ông Ích Đường, Cẩm Lệ, Đà Nẵng', '0935220012', 'dinhtruong@gmail.com', N'Nam', N'Tài xế'),
('KH_DN013', N'Phạm Hùng', N'Ngô Quyền, Sơn Trà, Đà Nẵng', '0935220013', 'hungpham@gmail.com', N'Nam', N'Sinh viên'),
('KH_DN014', N'Vũ Trọng Phụng', N'Hoàng Diệu, Hải Châu, Đà Nẵng', '0935220014', 'phungvu@gmail.com', N'Nam', N'Nhà văn'),
('KH_DN015', N'Tôn Đức Thắng', N'Nguyễn Lương Bằng, Liên Chiểu, Đà Nẵng', '0935220015', 'thangton@gmail.com', N'Nam', N'Giảng viên'),
('KH_DN016', N'Lê Lợi', N'Bạch Đằng, Sơn Trà, Đà Nẵng', '0935220016', 'loile@gmail.com', N'Nam', N'Kinh doanh BĐS'),
('KH_DN017', N'Bà Triệu', N'Lê Duẩn, Hải Châu, Đà Nẵng', '0935220017', 'trieuba@gmail.com', N'Nữ', N'Kinh doanh tự do'),
('KH_DN018', N'Hai Bà Trưng', N'Nguyễn Tri Phương, Thanh Khê, Đà Nẵng', '0935220018', 'trunghai@gmail.com', N'Nữ', N'Bác sĩ'),
('KH_DN019', N'Đinh Tiên Hoàng', N'Mai Đăng Chơn, Ngũ Hành Sơn, Đà Nẵng', '0935220019', 'hoangdinh@gmail.com', N'Nam', N'Kỹ sư IT'),
('KH_DN020', N'Quang Trung', N'Trường Chinh, Liên Chiểu, Đà Nẵng', '0935220020', 'trungquang@gmail.com', N'Nam', N'Công nhân'),
('KH_DN021', N'Trần Quốc Toản', N'Âu Cơ, Liên Chiểu, Đà Nẵng', '0935220021', 'toantran@gmail.com', N'Nam', N'Sinh viên'),
('KH_DN022', N'Bùi Viện', N'Nguyễn Bỉnh Khiêm, Sơn Trà, Đà Nẵng', '0935220022', 'vienbui@gmail.com', N'Nam', N'Ca sĩ'),
('KH_DN023', N'Cao Thắng', N'Lê Thanh Nghị, Hải Châu, Đà Nẵng', '0935220023', 'thangcao@gmail.com', N'Nam', N'Luật sư'),
('KH_DN024', N'Chu Văn An', N'Nguyễn Hữu Thọ, Cẩm Lệ, Đà Nẵng', '0935220024', 'anchu@gmail.com', N'Nam', N'Chủ doanh nghiệp'),
('KH_DN025', N'Phan Bội Châu', N'Hải Phòng, Hải Châu, Đà Nẵng', '0935220025', 'chauphan@gmail.com', N'Nam', N'Nhà báo'),
('KH_DN026', N'Trần Bình Trọng', N'Phan Đăng Lưu, Hải Châu, Đà Nẵng', '0935220026', 'trongtran@gmail.com', N'Nam', N'Kỹ sư cơ khí'),
('KH_DN027', N'Yết Kiêu', N'Ngô Văn Sở, Liên Chiểu, Đà Nẵng', '0935220027', 'kieuyet@gmail.com', N'Nam', N'Vận động viên'),
('KH_DN028', N'Dã Tượng', N'Võ Nguyên Giáp, Sơn Trà, Đà Nẵng', '0935220028', 'tuongda@gmail.com', N'Nam', N'Hướng dẫn viên'),
('KH_DN029', N'Thi Sách', N'Trần Cao Vân, Thanh Khê, Đà Nẵng', '0935220029', 'sachthi@gmail.com', N'Nam', N'Nghệ sĩ'),
('KH_DN030', N'Trần Nhân Tông', N'Phạm Cự Lượng, Ngũ Hành Sơn, Đà Nẵng', '0935220030', 'tongtran@gmail.com', N'Nam', N'Thiết kế đồ họa'),
('KH_DN031', N'Lê Thánh Tôn', N'Võ Chí Công, Ngũ Hành Sơn, Đà Nẵng', '0935220031', 'tonle@gmail.com', N'Nam', N'Quản lý dự án'),
('KH_DN032', N'Hàm Nghi', N'Lý Thái Tổ, Thanh Khê, Đà Nẵng', '0935220032', 'nghiham@gmail.com', N'Nam', N'Nhân viên ngân hàng'),
('KH_DN033', N'Mạc Đĩnh Chi', N'Khúc Hạo, Sơn Trà, Đà Nẵng', '0935220033', 'chimac@gmail.com', N'Nam', N'Nhân viên Sale'),
('KH_DN034', N'Lê Hoàn', N'Lương Nhữ Hộc, Hải Châu, Đà Nẵng', '0935220034', 'hoanle@gmail.com', N'Nam', N'Đầu bếp'),
('KH_DN035', N'Lý Thường Kiệt', N'Trần Đại Nghĩa, Ngũ Hành Sơn, Đà Nẵng', '0935220035', 'kietly@gmail.com', N'Nam', N'Nông dân'),
('KH_DN036', N'Trần Khát Chân', N'Cách Mạng Tháng 8, Cẩm Lệ, Đà Nẵng', '0935220036', 'chantran@gmail.com', N'Nam', N'Công nhân'),
('KH_DN037', N'Tô Hiến Thành', N'Núi Thành, Hải Châu, Đà Nẵng', '0935220037', 'thanhto@gmail.com', N'Nam', N'Bác sĩ'),
('KH_DN038', N'Phan Chu Trinh', N'Trần Đình Đàn, Sơn Trà, Đà Nẵng', '0935220038', 'trinhphan@gmail.com', N'Nam', N'Thợ mộc'),
('KH_DN039', N'Đinh Công Tráng', N'Huỳnh Thúc Kháng, Hải Châu, Đà Nẵng', '0935220039', 'trangdinh@gmail.com', N'Nam', N'Sinh viên'),
('KH_DN040', N'Nguyễn Bỉnh Khiêm', N'Đồng Kè, Liên Chiểu, Đà Nẵng', '0935220040', 'khiemnguyen@gmail.com', N'Nam', N'Thủy thủ');

-- [TAIKHOAN] - 50 Tài khoản (Tự động sinh bằng Vòng Lặp để code gọn nhẹ)
DECLARE @t INT = 1;
DECLARE @idKH_Random VARCHAR(20);
WHILE @t <= 50
BEGIN
    -- Chọn ngẫu nhiên khách hàng từ KH_DN001 đến KH_DN040
    SET @idKH_Random = 'KH_DN' + RIGHT('000' + CAST((@t % 40 + 1) AS VARCHAR), 3);
    
    INSERT INTO TAIKHOAN (idTai_Khoan, numTK, typeTK, balanceTK, idKH) 
    VALUES ('TK_DN' + RIGHT('000' + CAST(@t AS VARCHAR), 3), 
            '19040000' + RIGHT('00' + CAST(@t AS VARCHAR), 2), 
            CASE WHEN @t % 3 = 0 THEN N'Tiết kiệm' ELSE N'Thanh toán' END, 
            (@t * 15000000), 
            @idKH_Random);
    SET @t = @t + 1;
END;

-- [LAISUAT & LOAI_HOPDONG] (Đồng bộ với Global)
INSERT INTO LAISUAT VALUES 
('LS_01', 6.50, N'Lãi suất vay mua nhà ưu đãi năm đầu'),
('LS_02', 8.50, N'Lãi suất vay mua ô tô'),
('LS_03', 12.00, N'Lãi suất vay tiêu dùng tín chấp');

INSERT INTO LOAI_HOPDONG VALUES 
('LHD_01', N'Vay mua Bất động sản', 240, 'LS_01'),
('LHD_02', N'Vay mua Ô tô', 72, 'LS_02'),
('LHD_03', N'Vay Tiêu dùng', 36, 'LS_03');

-- [HOPDONG] - 20 Hợp đồng vay vốn
INSERT INTO HOPDONG VALUES 
('HD_DN001', '2023-05-10', 1500000000, 1300000000, N'Đang trả nợ', 'KH_DN004', 'LHD_01', 'NV_DN03'),
('HD_DN002', '2023-06-15', 700000000, 500000000, N'Đang trả nợ', 'KH_DN008', 'LHD_02', 'NV_DN04'),
('HD_DN003', '2023-08-20', 150000000, 100000000, N'Đang trả nợ', 'KH_DN015', 'LHD_03', 'NV_DN15'),
('HD_DN004', '2024-01-12', 2000000000, 1900000000, N'Đang trả nợ', 'KH_DN024', 'LHD_01', 'NV_DN05'),
('HD_DN005', '2024-02-28', 450000000, 400000000, N'Đang trả nợ', 'KH_DN018', 'LHD_02', 'NV_DN03'),
('HD_DN006', '2024-03-10', 80000000, 40000000, N'Đang trả nợ', 'KH_DN010', 'LHD_03', 'NV_DN04'),
('HD_DN007', '2024-04-05', 1200000000, 1100000000, N'Đang trả nợ', 'KH_DN012', 'LHD_01', 'NV_DN15'),
('HD_DN008', '2024-05-20', 600000000, 550000000, N'Đang trả nợ', 'KH_DN022', 'LHD_02', 'NV_DN03'),
('HD_DN009', '2024-06-18', 60000000, 50000000, N'Đang trả nợ', 'KH_DN029', 'LHD_03', 'NV_DN04'),
('HD_DN010', '2024-07-22', 2200000000, 2100000000, N'Đang trả nợ', 'KH_DN025', 'LHD_01', 'NV_DN06'),
('HD_DN011', '2024-08-11', 850000000, 800000000, N'Đang trả nợ', 'KH_DN031', 'LHD_02', 'NV_DN05'),
('HD_DN012', '2024-09-05', 150000000, 120000000, N'Đang trả nợ', 'KH_DN038', 'LHD_03', 'NV_DN15'),
('HD_DN013', '2024-09-15', 1600000000, 1550000000, N'Đang trả nợ', 'KH_DN007', 'LHD_01', 'NV_DN03'),
('HD_DN014', '2024-10-01', 500000000, 480000000, N'Đang trả nợ', 'KH_DN013', 'LHD_02', 'NV_DN04'),
('HD_DN015', '2024-10-10', 95000000, 90000000, N'Đang trả nợ', 'KH_DN020', 'LHD_03', 'NV_DN15'),
('HD_DN016', '2024-10-20', 3000000000, 2900000000, N'Đang trả nợ', 'KH_DN027', 'LHD_01', 'NV_DN06'),
('HD_DN017', '2024-11-05', 750000000, 730000000, N'Đang trả nợ', 'KH_DN036', 'LHD_02', 'NV_DN05'),
('HD_DN018', '2024-11-15', 70000000, 65000000, N'Đang trả nợ', 'KH_DN033', 'LHD_03', 'NV_DN03'),
('HD_DN019', '2024-11-20', 1800000000, 1750000000, N'Đang trả nợ', 'KH_DN002', 'LHD_01', 'NV_DN04'),
('HD_DN020', '2024-11-25', 350000000, 340000000, N'Đang trả nợ', 'KH_DN016', 'LHD_02', 'NV_DN15');

-- [GIAODICH_TINDUNG] - 80 Giao dịch (Tự động sinh)
DECLARE @g INT = 1;
DECLARE @idTK_Random VARCHAR(20);
DECLARE @idNV_Random VARCHAR(20);
WHILE @g <= 80
BEGIN
    SET @idTK_Random = 'TK_DN' + RIGHT('000' + CAST((@g % 50 + 1) AS VARCHAR), 3);
    SET @idNV_Random = 'NV_DN' + RIGHT('00' + CAST((@g % 4 + 7) AS VARCHAR), 2); -- Lấy NV Giao dịch viên (07-11)
    
    INSERT INTO GIAODICH_TINDUNG (idGD, timeGD, typeGD, numGD, statusGD, idTai_Khoan, idNhan_Vien) 
    VALUES ('GD_DN' + RIGHT('000' + CAST(@g AS VARCHAR), 3), 
            DATEADD(hour, @g, '2024-11-01 08:00:00'), 
            CASE 
                WHEN @g % 4 = 0 THEN N'Rút tiền mặt'
                WHEN @g % 4 = 1 THEN N'Chuyển khoản nội bộ'
                WHEN @g % 4 = 2 THEN N'Thanh toán POS'
                ELSE N'Nộp tiền mặt' 
            END, 
            (@g * 500000), 
            N'Thành công', 
            @idTK_Random,
            CASE WHEN @g % 2 = 0 THEN NULL ELSE @idNV_Random END); -- Giao dịch online thì ko có NV
    SET @g = @g + 1;
END;
GO

-- =========================================================================
-- HOÀN TẤT SCRIPT LOCAL SITE ĐÀ NẴNG
-- =========================================================================