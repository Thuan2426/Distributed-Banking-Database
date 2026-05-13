-- =========================================================================
-- ĐỒ ÁN HỆ QUẢN TRỊ CSDL NÂNG CAO - TECHCOMBANK
-- SCRIPT: USEDATABASE_Site1_HN.sql (CHI NHÁNH HÀ NỘI) - FINAL VERSION
-- =========================================================================

-- 1. TẠO DATABASE
CREATE DATABASE Techcombank_Site1_HN;
GO
USE Techcombank_Site1_HN;
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
-- 3. INSERT DỮ LIỆU ĐỊA PHƯƠNG (SITE HÀ NỘI)
-- =========================================================================

-- [CHINHANH & PHONGBAN]
INSERT INTO CHINHANH VALUES ('CN_HN', N'Techcombank Hội Sở & CN Hà Nội', N'191 Bà Triệu, Q. Hai Bà Trưng, Hà Nội', '024.3944.6368');
INSERT INTO PHONGBAN VALUES 
('PB_TD_HN', N'Phòng Tín Dụng Cá Nhân', 25, N'Khối Bán Lẻ'),
('PB_DN_HN', N'Phòng Tín Dụng Doanh Nghiệp', 20, N'Khối KHDN'),
('PB_CS_HN', N'Phòng Dịch Vụ Khách Hàng', 30, N'Khối Vận Hành'),
('PB_KT_HN', N'Phòng Kế Toán - Kho Quỹ', 15, N'Khối Nguồn Vốn');

-- [NHANVIEN] - 15 Nhân viên tại Hà Nội
INSERT INTO NHANVIEN VALUES 
('NV_HN01', N'Nguyễn Hoàng Anh', N'Đống Đa, Hà Nội', '0981110001', 'hoanganh.nv@techcombank.vn', N'Giám đốc Chi nhánh', 'PB_TD_HN'),
('NV_HN02', N'Lê Thị Bích', N'Ba Đình, Hà Nội', '0981110002', 'bich.lt@techcombank.vn', N'Trưởng phòng', 'PB_TD_HN'),
('NV_HN03', N'Trần Văn Cường', N'Cầu Giấy, Hà Nội', '0981110003', 'cuong.tv@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_HN'),
('NV_HN04', N'Phạm Thu Dung', N'Thanh Xuân, Hà Nội', '0981110004', 'dung.pt@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_HN'),
('NV_HN05', N'Hoàng Trọng Em', N'Hai Bà Trưng, Hà Nội', '0981110005', 'em.ht@techcombank.vn', N'Chuyên viên KHDN', 'PB_DN_HN'),
('NV_HN06', N'Vũ Bích Phượng', N'Hoàng Mai, Hà Nội', '0981110006', 'phuong.vb@techcombank.vn', N'Chuyên viên KHDN', 'PB_DN_HN'),
('NV_HN07', N'Đặng Văn Giang', N'Long Biên, Hà Nội', '0981110007', 'giang.dv@techcombank.vn', N'Giao dịch viên', 'PB_CS_HN'),
('NV_HN08', N'Bùi Thị Hằng', N'Tây Hồ, Hà Nội', '0981110008', 'hang.bt@techcombank.vn', N'Giao dịch viên', 'PB_CS_HN'),
('NV_HN09', N'Đỗ Minh Trí', N'Nam Từ Liêm, Hà Nội', '0981110009', 'tri.dm@techcombank.vn', N'Giao dịch viên', 'PB_CS_HN'),
('NV_HN10', N'Ngô Thanh Vân', N'Bắc Từ Liêm, Hà Nội', '0981110010', 'van.nt@techcombank.vn', N'Giao dịch viên', 'PB_CS_HN'),
('NV_HN11', N'Lý Hải Đăng', N'Hà Đông, Hà Nội', '0981110011', 'dang.lh@techcombank.vn', N'Giao dịch viên', 'PB_CS_HN'),
('NV_HN12', N'Tạ Gia Thuận', N'Hoàn Kiếm, Hà Nội', '0981110012', 'thuan.tg@techcombank.vn', N'Kế toán trưởng', 'PB_KT_HN'),
('NV_HN13', N'Lê Đặng Phước Thọ', N'Hoàn Kiếm, Hà Nội', '0981110013', 'tho.ldp@techcombank.vn', N'Kiểm soát viên', 'PB_KT_HN'),
('NV_HN14', N'Châu Tinh Trì', N'Ba Đình, Hà Nội', '0981110014', 'tri.ct@techcombank.vn', N'Thủ quỹ', 'PB_KT_HN'),
('NV_HN15', N'Lưu Diệc Phi', N'Tây Hồ, Hà Nội', '0981110015', 'phi.ld@techcombank.vn', N'Chuyên viên Tín dụng', 'PB_TD_HN');

-- [KHACHHANG] - 40 Khách hàng (100% địa chỉ chứa 'Hà Nội')
INSERT INTO KHACHHANG VALUES 
('KH_HN001', N'Trương Cảnh Anh', N'Số 12 ngõ 34 Cầu Giấy, Hà Nội', '0902220001', 'canhanh@gmail.com', N'Nam', N'Kỹ sư IT'),
('KH_HN002', N'Đinh Bích Phương', N'Số 45 Tôn Đức Thắng, Đống Đa, Hà Nội', '0902220002', 'bichphuong@gmail.com', N'Nữ', N'Giáo viên'),
('KH_HN003', N'Nguyễn Quang Hải', N'CT4 Vimeco, Nguyễn Chánh, Cầu Giấy, Hà Nội', '0902220003', 'quanghai@gmail.com', N'Nam', N'Cầu thủ'),
('KH_HN004', N'Lê Minh Đạo', N'KĐT Times City, Hai Bà Trưng, Hà Nội', '0902220004', 'minhdao@gmail.com', N'Nam', N'Kiến trúc sư'),
('KH_HN005', N'Trần Tuấn Hưng', N'Số 8 Nguyễn Trãi, Thanh Xuân, Hà Nội', '0902220005', 'tuanhung@gmail.com', N'Nam', N'Ca sĩ'),
('KH_HN006', N'Phạm Mỹ Linh', N'Royal City, Thanh Xuân, Hà Nội', '0902220006', 'mylinh@gmail.com', N'Nữ', N'Kế toán'),
('KH_HN007', N'Vũ Xuân Thành', N'Số 15 Kim Mã, Ba Đình, Hà Nội', '0902220007', 'xuanthanh@gmail.com', N'Nam', N'Luật sư'),
('KH_HN008', N'Đoàn Bảo Châu', N'Vinhomes Riverside, Long Biên, Hà Nội', '0902220008', 'baochau@gmail.com', N'Nữ', N'Giám đốc'),
('KH_HN009', N'Hồ Quốc Anh', N'Số 90 Đường Láng, Đống Đa, Hà Nội', '0902220009', 'quocanh@gmail.com', N'Nam', N'Lập trình viên'),
('KH_HN010', N'Ngô Quý Đôn', N'KĐT Mỹ Đình, Nam Từ Liêm, Hà Nội', '0902220010', 'quydon@gmail.com', N'Nam', N'Giảng viên'),
('KH_HN011', N'Dương Thu Thủy', N'Trần Hưng Đạo, Hoàn Kiếm, Hà Nội', '0902220011', 'thuthuy@gmail.com', N'Nữ', N'Nhân viên VP'),
('KH_HN012', N'Lý Hải Yến', N'Nguyễn Du, Hai Bà Trưng, Hà Nội', '0902220012', 'haiyen@gmail.com', N'Nữ', N'Thiết kế đồ họa'),
('KH_HN013', N'Mai Trọng Nhân', N'Lạc Long Quân, Tây Hồ, Hà Nội', '0902220013', 'trongnhan@gmail.com', N'Nam', N'Tài xế'),
('KH_HN014', N'Cao Thanh Tùng', N'Trương Định, Hoàng Mai, Hà Nội', '0902220014', 'thanhtung@gmail.com', N'Nam', N'Kinh doanh tự do'),
('KH_HN015', N'Nguyễn Văn Toàn', N'Xuân Thủy, Cầu Giấy, Hà Nội', '0902220015', 'vantoan@gmail.com', N'Nam', N'Sinh viên'),
('KH_HN016', N'Lê Đặng Tuấn', N'KĐT Mỗ Lao, Hà Đông, Hà Nội', '0902220016', 'tuanld@gmail.com', N'Nam', N'Bác sĩ'),
('KH_HN017', N'Tôn Ngộ Không', N'Đường Bưởi, Ba Đình, Hà Nội', '0902220017', 'ngokhong@gmail.com', N'Nam', N'Vận động viên'),
('KH_HN018', N'Bạch Cốt Tinh', N'Lò Đúc, Hai Bà Trưng, Hà Nội', '0902220018', 'cottinh@gmail.com', N'Nữ', N'Người mẫu'),
('KH_HN019', N'Đường Tam Tạng', N'Chùa Bộc, Đống Đa, Hà Nội', '0902220019', 'tamtang@gmail.com', N'Nam', N'Giảng viên'),
('KH_HN020', N'Trư Bát Giới', N'Chợ Đồng Xuân, Hoàn Kiếm, Hà Nội', '0902220020', 'batgioi@gmail.com', N'Nam', N'Đầu bếp'),
('KH_HN021', N'Trần Thu Hà', N'Hoàng Hoa Thám, Tây Hồ, Hà Nội', '0902220021', 'thuha.tran@gmail.com', N'Nữ', N'Ca sĩ'),
('KH_HN022', N'Phạm Tiến Dũng', N'Nguyễn Trãi, Thanh Xuân, Hà Nội', '0902220022', 'tiendung@gmail.com', N'Nam', N'Kỹ sư xây dựng'),
('KH_HN023', N'Nguyễn Thanh Trúc', N'Trần Duy Hưng, Cầu Giấy, Hà Nội', '0902220023', 'thanhtruc@gmail.com', N'Nữ', N'Nhân viên ngân hàng'),
('KH_HN024', N'Lê Đại Hành', N'Hoa Lư, Hai Bà Trưng, Hà Nội', '0902220024', 'daihanh@gmail.com', N'Nam', N'Chủ doanh nghiệp'),
('KH_HN025', N'Võ Tắc Thiên', N'KĐT Ciputra, Tây Hồ, Hà Nội', '0902220025', 'tacthien@gmail.com', N'Nữ', N'CEO'),
('KH_HN026', N'Hoàng Đạo Thúy', N'Lê Văn Lương, Thanh Xuân, Hà Nội', '0902220026', 'daothuy@gmail.com', N'Nam', N'Nhà báo'),
('KH_HN027', N'Ngô Đình Diệm', N'Phan Đình Phùng, Ba Đình, Hà Nội', '0902220027', 'dinhdiem@gmail.com', N'Nam', N'Chuyên gia tài chính'),
('KH_HN028', N'Đặng Thái Sơn', N'Lý Thái Tổ, Hoàn Kiếm, Hà Nội', '0902220028', 'thaison@gmail.com', N'Nam', N'Nghệ sĩ Piano'),
('KH_HN029', N'Lâm Tâm Như', N'Vinhomes Ocean Park, Gia Lâm, Hà Nội', '0902220029', 'tamnhu@gmail.com', N'Nữ', N'Diễn viên'),
('KH_HN030', N'Triệu Vy', N'Vinhomes Smart City, Nam Từ Liêm, Hà Nội', '0902220030', 'trieuvy@gmail.com', N'Nữ', N'Đạo diễn'),
('KH_HN031', N'Phạm Băng Băng', N'KĐT Ecopark (gần Hà Nội), Hà Nội', '0902220031', 'bangbang@gmail.com', N'Nữ', N'Doanh nhân'),
('KH_HN032', N'Trần Quán Hy', N'Bùi Viện (Chi nhánh Hà Nội), Hoàn Kiếm, Hà Nội', '0902220032', 'quanhy@gmail.com', N'Nam', N'Kinh doanh'),
('KH_HN033', N'Tạ Đình Phong', N'Quang Trung, Hà Đông, Hà Nội', '0902220033', 'dinhphong@gmail.com', N'Nam', N'Đầu bếp'),
('KH_HN034', N'Trương Bá Chi', N'Lê Trọng Tấn, Thanh Xuân, Hà Nội', '0902220034', 'bachi@gmail.com', N'Nữ', N'Nội trợ'),
('KH_HN035', N'Vương Phi', N'Cát Linh, Đống Đa, Hà Nội', '0902220035', 'vuongphi@gmail.com', N'Nữ', N'Ca sĩ'),
('KH_HN036', N'Quách Phú Thành', N'Đội Cấn, Ba Đình, Hà Nội', '0902220036', 'phuthanh@gmail.com', N'Nam', N'Vũ công'),
('KH_HN037', N'Lưu Đức Hoa', N'Giảng Võ, Đống Đa, Hà Nội', '0902220037', 'duchoa@gmail.com', N'Nam', N'Sản xuất phim'),
('KH_HN038', N'Lê Minh', N'Khâm Thiên, Đống Đa, Hà Nội', '0902220038', 'leminh@gmail.com', N'Nam', N'Kiến trúc sư'),
('KH_HN039', N'Trương Học Hữu', N'Nguyễn Thái Học, Ba Đình, Hà Nội', '0902220039', 'hochuu@gmail.com', N'Nam', N'Nhà văn'),
('KH_HN040', N'Cổ Thiên Lạc', N'Thụy Khuê, Tây Hồ, Hà Nội', '0902220040', 'thienlac@gmail.com', N'Nam', N'Kinh doanh BĐS');

-- [TAIKHOAN] - 50 Tài khoản (Tự động sinh bằng Vòng Lặp)
DECLARE @t INT = 1;
DECLARE @idKH_Random VARCHAR(20);
WHILE @t <= 50
BEGIN
    SET @idKH_Random = 'KH_HN' + RIGHT('000' + CAST((@t % 40 + 1) AS VARCHAR), 3);
    INSERT INTO TAIKHOAN (idTai_Khoan, numTK, typeTK, balanceTK, idKH) 
    VALUES ('TK_HN' + RIGHT('000' + CAST(@t AS VARCHAR), 3), 
            '19030000' + RIGHT('00' + CAST(@t AS VARCHAR), 2), 
            CASE WHEN @t % 3 = 0 THEN N'Tiết kiệm' ELSE N'Thanh toán' END, 
            (@t * 10000000), 
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
('HD_HN001', '2023-05-10', 2000000000, 1800000000, N'Đang trả nợ', 'KH_HN004', 'LHD_01', 'NV_HN03'),
('HD_HN002', '2023-06-15', 800000000, 600000000, N'Đang trả nợ', 'KH_HN008', 'LHD_02', 'NV_HN04'),
('HD_HN003', '2023-08-20', 100000000, 50000000, N'Đang trả nợ', 'KH_HN015', 'LHD_03', 'NV_HN15'),
('HD_HN004', '2024-01-12', 3000000000, 2900000000, N'Đang trả nợ', 'KH_HN024', 'LHD_01', 'NV_HN05'),
('HD_HN005', '2024-02-28', 500000000, 450000000, N'Đang trả nợ', 'KH_HN018', 'LHD_02', 'NV_HN03'),
('HD_HN006', '2024-03-10', 50000000, 10000000, N'Đang trả nợ', 'KH_HN010', 'LHD_03', 'NV_HN04'),
('HD_HN007', '2024-04-05', 1500000000, 1400000000, N'Đang trả nợ', 'KH_HN012', 'LHD_01', 'NV_HN15'),
('HD_HN008', '2024-05-20', 700000000, 650000000, N'Đang trả nợ', 'KH_HN022', 'LHD_02', 'NV_HN03'),
('HD_HN009', '2024-06-18', 80000000, 70000000, N'Đang trả nợ', 'KH_HN029', 'LHD_03', 'NV_HN04'),
('HD_HN010', '2024-07-22', 2500000000, 2450000000, N'Đang trả nợ', 'KH_HN025', 'LHD_01', 'NV_HN06'),
('HD_HN011', '2024-08-11', 900000000, 880000000, N'Đang trả nợ', 'KH_HN031', 'LHD_02', 'NV_HN05'),
('HD_HN012', '2024-09-05', 120000000, 110000000, N'Đang trả nợ', 'KH_HN038', 'LHD_03', 'NV_HN15'),
('HD_HN013', '2024-09-15', 1800000000, 1750000000, N'Đang trả nợ', 'KH_HN007', 'LHD_01', 'NV_HN03'),
('HD_HN014', '2024-10-01', 600000000, 580000000, N'Đang trả nợ', 'KH_HN013', 'LHD_02', 'NV_HN04'),
('HD_HN015', '2024-10-10', 90000000, 85000000, N'Đang trả nợ', 'KH_HN020', 'LHD_03', 'NV_HN15'),
('HD_HN016', '2024-10-20', 3500000000, 3450000000, N'Đang trả nợ', 'KH_HN027', 'LHD_01', 'NV_HN06'),
('HD_HN017', '2024-11-05', 850000000, 830000000, N'Đang trả nợ', 'KH_HN036', 'LHD_02', 'NV_HN05'),
('HD_HN018', '2024-11-15', 60000000, 58000000, N'Đang trả nợ', 'KH_HN033', 'LHD_03', 'NV_HN03'),
('HD_HN019', '2024-11-20', 2200000000, 2180000000, N'Đang trả nợ', 'KH_HN002', 'LHD_01', 'NV_HN04'),
('HD_HN020', '2024-11-25', 400000000, 390000000, N'Đang trả nợ', 'KH_HN016', 'LHD_02', 'NV_HN15');

-- [GIAODICH_TINDUNG] - 80 Giao dịch (Tự động sinh)
DECLARE @g INT = 1;
DECLARE @idTK_Random VARCHAR(20);
DECLARE @idNV_Random VARCHAR(20);
WHILE @g <= 80
BEGIN
    SET @idTK_Random = 'TK_HN' + RIGHT('000' + CAST((@g % 50 + 1) AS VARCHAR), 3);
    SET @idNV_Random = 'NV_HN' + RIGHT('00' + CAST((@g % 5 + 7) AS VARCHAR), 2); -- Lấy NV Giao dịch viên (07-11)
    
    INSERT INTO GIAODICH_TINDUNG (idGD, timeGD, typeGD, numGD, statusGD, idTai_Khoan, idNhan_Vien) 
    VALUES ('GD_HN' + RIGHT('000' + CAST(@g AS VARCHAR), 3), 
            DATEADD(hour, @g, '2024-11-01 08:00:00'), 
            CASE 
                WHEN @g % 4 = 0 THEN N'Rút tiền mặt'
                WHEN @g % 4 = 1 THEN N'Chuyển khoản nội bộ'
                WHEN @g % 4 = 2 THEN N'Thanh toán POS'
                ELSE N'Nộp tiền mặt' 
            END, 
            (@g * 300000), 
            N'Thành công', 
            @idTK_Random,
            CASE WHEN @g % 2 = 0 THEN NULL ELSE @idNV_Random END); -- Giao dịch online thì ko có NV
    SET @g = @g + 1;
END;
GO

-- =========================================================================
-- HOÀN TẤT SCRIPT LOCAL SITE HÀ NỘI
-- =========================================================================