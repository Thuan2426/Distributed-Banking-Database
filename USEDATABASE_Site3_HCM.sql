-- =========================================================================
-- ĐỒ ÁN HỆ QUẢN TRỊ CSDL NÂNG CAO - TECHCOMBANK
-- SCRIPT: USEDATABASE_Site3_HCM.sql (CHI NHÁNH TP. HỒ CHÍ MINH)
-- =========================================================================

-- 1. TẠO DATABASE
CREATE DATABASE Techcombank_Site3_HCM;
GO
USE Techcombank_Site3_HCM;
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
-- 3. INSERT DỮ LIỆU ĐỊA PHƯƠNG (SITE TP.HCM)
-- =========================================================================

-- [CHINHANH & PHONGBAN]
INSERT INTO CHINHANH VALUES ('CN_HCM', N'Techcombank CN Sài Gòn', N'Lê Duẩn, Quận 1, TP.HCM', '028.3822.1234');
INSERT INTO PHONGBAN VALUES 
('PB_TD_HCM', N'Phòng Tín Dụng Cá Nhân', 30, N'Khối Bán Lẻ'),
('PB_DN_HCM', N'Phòng Tín Dụng Doanh Nghiệp', 25, N'Khối KHDN'),
('PB_CS_HCM', N'Phòng Dịch Vụ Khách Hàng', 40, N'Khối Vận Hành'),
('PB_KT_HCM', N'Phòng Kế Toán - Kho Quỹ', 15, N'Khối Nguồn Vốn');

-- [NHANVIEN] - 15 Nhân viên tại TP.HCM
INSERT INTO NHANVIEN VALUES 
('NV_HCM01', N'Nguyễn Vĩnh Nghiêm', N'Quận 3, TP.HCM', '0908110001', 'nghiem.nv@techcombank.vn', N'Giám đốc Chi nhánh', 'PB_TD_HCM'),
('NV_HCM02', N'Lê Tấn Tài', N'Quận 7, TP.HCM', '0908110002', 'tai.lt@techcombank.vn', N'Trưởng phòng', 'PB_TD_HCM'),
('NV_HCM03', N'Trương Mỹ Lan', N'Quận 1, TP.HCM', '0908110003', 'lan.tm@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_HCM'),
('NV_HCM04', N'Võ Văn Tần', N'Tân Bình, TP.HCM', '0908110004', 'tan.vv@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_HCM'),
('NV_HCM05', N'Lý Tự Trọng', N'Gò Vấp, TP.HCM', '0908110005', 'trong.lt@techcombank.vn', N'Chuyên viên KHDN', 'PB_DN_HCM'),
('NV_HCM06', N'Huỳnh Phú Sổ', N'Phú Nhuận, TP.HCM', '0908110006', 'so.hp@techcombank.vn', N'Chuyên viên KHDN', 'PB_DN_HCM'),
('NV_HCM07', N'Đoàn Văn Bơ', N'Quận 4, TP.HCM', '0908110007', 'bo.dv@techcombank.vn', N'Giao dịch viên', 'PB_CS_HCM'),
('NV_HCM08', N'Tôn Thất Thuyết', N'Quận 10, TP.HCM', '0908110008', 'thuyet.tt@techcombank.vn', N'Giao dịch viên', 'PB_CS_HCM'),
('NV_HCM09', N'Cao Thắng', N'Quận 3, TP.HCM', '0908110009', 'thang.c@techcombank.vn', N'Giao dịch viên', 'PB_CS_HCM'),
('NV_HCM10', N'Nguyễn Đình Chiểu', N'Quận 1, TP.HCM', '0908110010', 'chieu.nd@techcombank.vn', N'Giao dịch viên', 'PB_CS_HCM'),
('NV_HCM11', N'Trần Hưng Đạo', N'Quận 5, TP.HCM', '0908110011', 'dao.th@techcombank.vn', N'Giao dịch viên', 'PB_CS_HCM'),
('NV_HCM12', N'Lê Lợi', N'Bình Thạnh, TP.HCM', '0908110012', 'loi.l@techcombank.vn', N'Kế toán trưởng', 'PB_KT_HCM'),
('NV_HCM13', N'Phạm Ngũ Lão', N'Quận 8, TP.HCM', '0908110013', 'lao.pn@techcombank.vn', N'Kiểm soát viên', 'PB_KT_HCM'),
('NV_HCM14', N'Hàm Nghi', N'Tân Phú, TP.HCM', '0908110014', 'nghi.h@techcombank.vn', N'Thủ quỹ', 'PB_KT_HCM'),
('NV_HCM15', N'Lê Lai', N'Quận 6, TP.HCM', '0908110015', 'lai.l@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_HCM');

-- [KHACHHANG] - 40 Khách hàng (100% địa chỉ chứa 'TP.HCM')
INSERT INTO KHACHHANG VALUES 
('KH_HCM001', N'Huỳnh Tấn Phát', N'Nguyễn Hữu Cảnh, Quận 1, TP.HCM', '0903220001', 'phathuynh@gmail.com', N'Nam', N'Kinh doanh'),
('KH_HCM002', N'Lê Văn Sỹ', N'Đường 3/2, Quận 10, TP.HCM', '0903220002', 'sylevan@gmail.com', N'Nam', N'Bác sĩ'),
('KH_HCM003', N'Nguyễn Thái Bình', N'Cộng Hòa, Tân Bình, TP.HCM', '0903220003', 'binhnguyen@gmail.com', N'Nam', N'Kỹ sư'),
('KH_HCM004', N'Trần Bình Trọng', N'Phan Đăng Lưu, Phú Nhuận, TP.HCM', '0903220004', 'trongtran@gmail.com', N'Nam', N'Kiến trúc sư'),
('KH_HCM005', N'Võ Tánh', N'Lê Trọng Tấn, Tân Phú, TP.HCM', '0903220005', 'tanhvo@gmail.com', N'Nam', N'Giám đốc'),
('KH_HCM006', N'Phạm Văn Đồng', N'Kha Vạn Cân, Liên Chiểu, TP.HCM', '0903220006', 'dongpham@gmail.com', N'Nam', N'Kế toán'),
('KH_HCM007', N'Đinh Tiên Hoàng', N'Bạch Đằng, Bình Thạnh, TP.HCM', '0903220007', 'hoangdinh@gmail.com', N'Nam', N'Chủ nhà hàng'),
('KH_HCM008', N'Lý Tự Trọng', N'Nguyễn Trãi, Quận 5, TP.HCM', '0903220008', 'trongly@gmail.com', N'Nam', N'Chủ doanh nghiệp'),
('KH_HCM009', N'Đặng Văn Ngữ', N'Võ Văn Ngân, TP Thủ Đức, TP.HCM', '0903220009', 'ngudang@gmail.com', N'Nam', N'Giáo viên'),
('KH_HCM010', N'Hoàng Văn Thụ', N'Trường Chinh, Tân Bình, TP.HCM', '0903220010', 'thuhoang@gmail.com', N'Nam', N'Lập trình viên'),
('KH_HCM011', N'Trần Nhân Tông', N'Hậu Giang, Quận 6, TP.HCM', '0903220011', 'tongtran@gmail.com', N'Nam', N'Nhân viên VP'),
('KH_HCM012', N'Nguyễn Chí Thanh', N'Lý Thường Kiệt, Quận 10, TP.HCM', '0903220012', 'thanhnguyen@gmail.com', N'Nam', N'Tài xế'),
('KH_HCM013', N'Lê Hồng Phong', N'Quang Trung, Gò Vấp, TP.HCM', '0903220013', 'phongle@gmail.com', N'Nam', N'Sinh viên'),
('KH_HCM014', N'Phan Đình Phùng', N'Phạm Văn Chiêu, TP Thủ Đức, TP.HCM', '0903220014', 'phungphan@gmail.com', N'Nam', N'Nhà văn'),
('KH_HCM015', N'Tôn Thất Hiệp', N'Bến Vân Đồn, Quận 6, TP.HCM', '0903220015', 'hiepton@gmail.com', N'Nam', N'Giảng viên'),
('KH_HCM016', N'Cao Thắng', N'Võ Thị Sáu, Quận 3, TP.HCM', '0903220016', 'thangcao@gmail.com', N'Nam', N'Kinh doanh BĐS'),
('KH_HCM017', N'Bà Huyện Thanh Quan', N'Hai Bà Trưng, Quận 1, TP.HCM', '0903220017', 'quanba@gmail.com', N'Nữ', N'Kinh doanh tự do'),
('KH_HCM018', N'Hai Bà Trưng', N'Cách Mạng Tháng 8, Quận 3, TP.HCM', '0903220018', 'trunghai@gmail.com', N'Nữ', N'Bác sĩ'),
('KH_HCM019', N'Đinh Tiên Hoàng', N'Lê Văn Sỹ, Quận 3, TP.HCM', '0903220019', 'hoangdinh2@gmail.com', N'Nam', N'Kỹ sư IT'),
('KH_HCM020', N'Quang Trung', N'Nguyễn Kiệm, Gò Vấp, TP.HCM', '0903220020', 'trungquang@gmail.com', N'Nam', N'Công nhân'),
('KH_HCM021', N'Trần Quốc Toản', N'Âu Cơ, Tân Phú, TP.HCM', '0903220021', 'toantran@gmail.com', N'Nam', N'Sinh viên'),
('KH_HCM022', N'Bùi Viện', N'Phạm Ngũ Lão, Quận 1, TP.HCM', '0903220022', 'vienbui@gmail.com', N'Nam', N'Hướng dẫn viên'),
('KH_HCM023', N'Nguyễn Trãi', N'Hải Thượng Lãn Ông, Quận 5, TP.HCM', '0903220023', 'trainguyen@gmail.com', N'Nam', N'Kinh doanh Vàng bạc'),
('KH_HCM024', N'Chu Văn An', N'Nơ Trang Long, Bình Thạnh, TP.HCM', '0903220024', 'anchu@gmail.com', N'Nam', N'Quản lý giáo dục'),
('KH_HCM025', N'Phan Bội Châu', N'Xô Viết Nghệ Tĩnh, Bình Thạnh, TP.HCM', '0903220025', 'chauphan@gmail.com', N'Nam', N'Thợ chụp ảnh'),
('KH_HCM026', N'Trần Bình Trọng', N'Phan Đăng Lưu, Phú Nhuận, TP.HCM', '0903220026', 'trongtran2@gmail.com', N'Nam', N'Kỹ sư cơ khí'),
('KH_HCM027', N'Yết Kiêu', N'Hoàng Sa, Quận 4, TP.HCM', '0903220027', 'kieuyet@gmail.com', N'Nam', N'Thủy thủ'),
('KH_HCM028', N'Dã Tượng', N'Trần Xuân Soạn, Quận 4, TP.HCM', '0903220028', 'tuongda@gmail.com', N'Nam', N'Giao nhận'),
('KH_HCM029', N'Trần Não', N'Nguyễn Oanh, Gò Vấp, TP.HCM', '0903220029', 'naotran@gmail.com', N'Nam', N'Môi giới BĐS'),
('KH_HCM030', N'Nguyễn Hữu Cảnh', N'Điện Biên Phủ, Bình Thạnh, TP.HCM', '0903220030', 'canhnguyen@gmail.com', N'Nam', N'Thiết kế đồ họa'),
('KH_HCM031', N'Lê Thánh Tôn', N'Tôn Đức Thắng, Quận 1, TP.HCM', '0903220031', 'tonle@gmail.com', N'Nam', N'Quản lý dự án'),
('KH_HCM032', N'Hàm Nghi', N'Nguyễn Thái Học, Quận 1, TP.HCM', '0903220032', 'nghiham@gmail.com', N'Nam', N'Nhân viên ngân hàng'),
('KH_HCM033', N'Mạc Đĩnh Chi', N'Lý Tự Trọng, Quận 1, TP.HCM', '0903220033', 'chimac@gmail.com', N'Nam', N'Nhân viên Sale'),
('KH_HCM034', N'Lê Đại Hành', N'Lũy Bán Bích, Tân Phú, TP.HCM', '0903220034', 'hanhle@gmail.com', N'Nam', N'Đầu bếp'),
('KH_HCM035', N'Lý Thường Kiệt', N'Lê Đại Hành, Quận 11, TP.HCM', '0903220035', 'kietly@gmail.com', N'Nam', N'Kinh doanh linh kiện'),
('KH_HCM036', N'Lạc Long Quân', N'Âu Cơ, Quận 11, TP.HCM', '0903220036', 'quanlac@gmail.com', N'Nam', N'Thợ điện'),
('KH_HCM037', N'Tô Hiến Thành', N'Cách Mạng Tháng 8, Quận 10, TP.HCM', '0903220037', 'thanhto@gmail.com', N'Nam', N'Bác sĩ'),
('KH_HCM038', N'Phan Chu Trinh', N'Trần Hưng Đạo, Quận 5, TP.HCM', '0903220038', 'trinhphan@gmail.com', N'Nam', N'Thợ may'),
('KH_HCM039', N'Đinh Tiên Hoàng', N'Phan Xích Long, Phú Nhuận, TP.HCM', '0903220039', 'hoangdinh3@gmail.com', N'Nam', N'Chủ Spa'),
('KH_HCM040', N'Nguyễn Bỉnh Khiêm', N'Đỗ Xuân Hợp, TP Thủ Đức, TP.HCM', '0903220040', 'khiemnguyen@gmail.com', N'Nam', N'Thợ máy');

-- [TAIKHOAN] - 50 Tài khoản (Tự động sinh bằng Vòng Lặp)
DECLARE @t INT = 1;
DECLARE @idKH_Random VARCHAR(20);
WHILE @t <= 50
BEGIN
    -- Chọn ngẫu nhiên khách hàng từ KH_HCM001 đến KH_HCM040
    SET @idKH_Random = 'KH_HCM' + RIGHT('000' + CAST((@t % 40 + 1) AS VARCHAR), 3);
    
    INSERT INTO TAIKHOAN (idTai_Khoan, numTK, typeTK, balanceTK, idKH) 
    VALUES ('TK_HCM' + RIGHT('000' + CAST(@t AS VARCHAR), 3), 
            '19050000' + RIGHT('00' + CAST(@t AS VARCHAR), 2), 
            CASE WHEN @t % 4 = 0 THEN N'Tiết kiệm' ELSE N'Thanh toán' END, 
            (@t * 25000000), 
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
('HD_HCM001', '2023-05-10', 3500000000, 3100000000, N'Đang trả nợ', 'KH_HCM004', 'LHD_01', 'NV_HCM03'),
('HD_HCM002', '2023-06-15', 900000000, 700000000, N'Đang trả nợ', 'KH_HCM008', 'LHD_02', 'NV_HCM04'),
('HD_HCM003', '2023-08-20', 250000000, 100000000, N'Đang trả nợ', 'KH_HCM015', 'LHD_03', 'NV_HCM15'),
('HD_HCM004', '2024-01-12', 4000000000, 3900000000, N'Đang trả nợ', 'KH_HCM024', 'LHD_01', 'NV_HCM05'),
('HD_HCM005', '2024-02-28', 850000000, 800000000, N'Đang trả nợ', 'KH_HCM018', 'LHD_02', 'NV_HCM03'),
('HD_HCM006', '2024-03-10', 180000000, 140000000, N'Đang trả nợ', 'KH_HCM010', 'LHD_03', 'NV_HCM04'),
('HD_HCM007', '2024-04-05', 2200000000, 2100000000, N'Đang trả nợ', 'KH_HCM012', 'LHD_01', 'NV_HCM15'),
('HD_HCM008', '2024-05-20', 960000000, 950000000, N'Đang trả nợ', 'KH_HCM022', 'LHD_02', 'NV_HCM03'),
('HD_HCM009', '2024-06-18', 90000000, 80000000, N'Đang trả nợ', 'KH_HCM029', 'LHD_03', 'NV_HCM04'),
('HD_HCM010', '2024-07-22', 5200000000, 5100000000, N'Đang trả nợ', 'KH_HCM025', 'LHD_01', 'NV_HCM06'),
('HD_HCM011', '2024-08-11', 1250000000, 1200000000, N'Đang trả nợ', 'KH_HCM031', 'LHD_02', 'NV_HCM05'),
('HD_HCM012', '2024-09-05', 250000000, 220000000, N'Đang trả nợ', 'KH_HCM038', 'LHD_03', 'NV_HCM15'),
('HD_HCM013', '2024-09-15', 3600000000, 3550000000, N'Đang trả nợ', 'KH_HCM007', 'LHD_01', 'NV_HCM03'),
('HD_HCM014', '2024-10-01', 700000000, 680000000, N'Đang trả nợ', 'KH_HCM013', 'LHD_02', 'NV_HCM04'),
('HD_HCM015', '2024-10-10', 195000000, 190000000, N'Đang trả nợ', 'KH_HCM020', 'LHD_03', 'NV_HCM15'),
('HD_HCM016', '2024-10-20', 4000000000, 3900000000, N'Đang trả nợ', 'KH_HCM027', 'LHD_01', 'NV_HCM06'),
('HD_HCM017', '2024-11-05', 950000000, 930000000, N'Đang trả nợ', 'KH_HCM036', 'LHD_02', 'NV_HCM05'),
('HD_HCM018', '2024-11-15', 170000000, 165000000, N'Đang trả nợ', 'KH_HCM033', 'LHD_03', 'NV_HCM03'),
('HD_HCM019', '2024-11-20', 2800000000, 2750000000, N'Đang trả nợ', 'KH_HCM002', 'LHD_01', 'NV_HCM04'),
('HD_HCM020', '2024-11-25', 550000000, 540000000, N'Đang trả nợ', 'KH_HCM016', 'LHD_02', 'NV_HCM15');

-- [GIAODICH_TINDUNG] - 80 Giao dịch (Tự động sinh)
DECLARE @g INT = 1;
DECLARE @idTK_Random VARCHAR(20);
DECLARE @idNV_Random VARCHAR(20);
WHILE @g <= 80
BEGIN
    SET @idTK_Random = 'TK_HCM' + RIGHT('000' + CAST((@g % 50 + 1) AS VARCHAR), 3);
    SET @idNV_Random = 'NV_HCM' + RIGHT('00' + CAST((@g % 5 + 7) AS VARCHAR), 2); -- Lấy NV Giao dịch viên (07-11)
    
    INSERT INTO GIAODICH_TINDUNG (idGD, timeGD, typeGD, numGD, statusGD, idTai_Khoan, idNhan_Vien) 
    VALUES ('GD_HCM' + RIGHT('000' + CAST(@g AS VARCHAR), 3), 
            DATEADD(hour, @g, '2024-11-01 08:00:00'), 
            CASE 
                WHEN @g % 4 = 0 THEN N'Rút tiền mặt'
                WHEN @g % 4 = 1 THEN N'Chuyển khoản nội bộ'
                WHEN @g % 4 = 2 THEN N'Thanh toán POS'
                ELSE N'Nộp tiền mặt' 
            END, 
            (@g * 800000), 
            N'Thành công', 
            @idTK_Random,
            CASE WHEN @g % 2 = 0 THEN NULL ELSE @idNV_Random END); -- Giao dịch online thì ko có NV
    SET @g = @g + 1;
END;
GO


-- =========================================================================
-- HOÀN TẤT SCRIPT LOCAL SITE TP.HCM
-- =========================================================================