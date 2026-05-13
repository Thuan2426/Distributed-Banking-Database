--- Câu 1: Distributed Partitioned View -------------------------------------------------------------------------------
CREATE VIEW V_TONGHOP_TAISAN_TOANQUOC AS
    -- Dữ liệu từ SITE 1 (HÀ NỘI) qua SERVER_HN
    SELECT 
        N'Hà Nội' AS KhuVuc, K.idKH, K.nameKH, K.numberKH,
        ISNULL(SUM(T.balanceTK), 0) AS TongSoDu,
        ISNULL(SUM(H.remainHD), 0) AS TongDuNo
    FROM [SERVER_HN].[Techcombank_Site1_HN].[dbo].[KHACHHANG] K
    LEFT JOIN [SERVER_HN].[Techcombank_Site1_HN].[dbo].[TAIKHOAN] T ON K.idKH = T.idKH
    LEFT JOIN [SERVER_HN].[Techcombank_Site1_HN].[dbo].[HOPDONG] H ON K.idKH = H.idKH
    GROUP BY K.idKH, K.nameKH, K.numberKH
    
    UNION ALL
    
    -- Dữ liệu từ SITE 2 (ĐÀ NẴNG) qua SERVER_DN
    SELECT 
        N'Đà Nẵng' AS KhuVuc, K.idKH, K.nameKH, K.numberKH,
        ISNULL(SUM(T.balanceTK), 0) AS TongSoDu,
        ISNULL(SUM(H.remainHD), 0) AS TongDuNo
    FROM [SERVER_DN].[Techcombank_Site2_DN].[dbo].[KHACHHANG] K
    LEFT JOIN [SERVER_DN].[Techcombank_Site2_DN].[dbo].[TAIKHOAN] T ON K.idKH = T.idKH
    LEFT JOIN [SERVER_DN].[Techcombank_Site2_DN].[dbo].[HOPDONG] H ON K.idKH = H.idKH
    GROUP BY K.idKH, K.nameKH, K.numberKH
    
    UNION ALL
    
    -- Dữ liệu từ SITE 3 (TP.HCM) qua SERVER_HCM
    SELECT 
        N'TP.HCM' AS KhuVuc, K.idKH, K.nameKH, K.numberKH,
        ISNULL(SUM(T.balanceTK), 0) AS TongSoDu,
        ISNULL(SUM(H.remainHD), 0) AS TongDuNo
    FROM [SERVER_HCM].[Techcombank_Site3_HCM].[dbo].[KHACHHANG] K
    LEFT JOIN [SERVER_HCM].[Techcombank_Site3_HCM].[dbo].[TAIKHOAN] T ON K.idKH = T.idKH
    LEFT JOIN [SERVER_HCM].[Techcombank_Site3_HCM].[dbo].[HOPDONG] H ON K.idKH = H.idKH
    GROUP BY K.idKH, K.nameKH, K.numberKH;
GO
-- Lệnh chạy ra kết quả View 
SELECT 
    KhuVuc, 
    idKH, 
    nameKH, 
    numberKH, 
    FORMAT(TongSoDu, 'N0') + ' VNĐ' AS SoDu_TietKiem,
    FORMAT(TongDuNo, 'N0') + ' VNĐ' AS DuNo_ChoVay
FROM V_TONGHOP_TAISAN_TOANQUOC
ORDER BY KhuVuc DESC;

--- Câu 2:Distributed Trigger -----------------------------------------------------------------------------------------
ALTER TRIGGER trg_DongBo_LaiSuat_XuyenChiNhanh
ON LAISUAT AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; 
    DECLARE @idLS VARCHAR(20), @rateMoi DECIMAL(5,2);
    SELECT @idLS = idLai_Suat, @rateMoi = rateLS FROM inserted;
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'UPDATE [Techcombank_Site1_HN].[dbo].[LAISUAT] SET rateLS = ' + CAST(@rateMoi AS NVARCHAR) + 
               N' WHERE idLai_Suat = ''' + @idLS + N'''';
    DECLARE @sql2 NVARCHAR(MAX);
    SET @sql2 = REPLACE(@sql, 'Site1_HN', 'Site2_DN');
    DECLARE @sql3 NVARCHAR(MAX);
    SET @sql3 = REPLACE(@sql, 'Site1_HN', 'Site3_HCM');
    BEGIN TRY
        EXEC [SERVER_HN].master.dbo.sp_executesql @sql;
        EXEC [SERVER_DN].master.dbo.sp_executesql @sql2;
        EXEC [SERVER_HCM].master.dbo.sp_executesql @sql3;
        PRINT N'CHÚC MỪNG: Hệ thống đã đồng bộ lãi suất ' + CAST(@rateMoi AS VARCHAR) + N' thành công!';
    END TRY
    BEGIN CATCH
        DECLARE @Err NVARCHAR(MAX) = ERROR_MESSAGE();
        PRINT N'THÔNG BÁO: ' + @Err;
    END CATCH
END;
GO
--TRƯỚC KHI ĐỒNG BỘ
SELECT N'Hà Nội' AS ChiNhanh, idLai_Suat, rateLS FROM [SERVER_HN].[Techcombank_Site1_HN].[dbo].[LAISUAT] WHERE idLai_Suat = 'LS_01'
UNION ALL
SELECT N'Đà Nẵng' AS ChiNhanh, idLai_Suat, rateLS FROM [SERVER_DN].[Techcombank_Site2_DN].[dbo].[LAISUAT] WHERE idLai_Suat = 'LS_01'
UNION ALL
SELECT N'TP.HCM' AS ChiNhanh, idLai_Suat, rateLS FROM [SERVER_HCM].[Techcombank_Site3_HCM].[dbo].[LAISUAT] WHERE idLai_Suat = 'LS_01';
-- THỰC THI TRIGGER 
UPDATE Techcombank_Global.dbo.LAISUAT 
SET rateLS = 14.5 
WHERE idLai_Suat = 'LS_01';
-- SAU KHI ĐỒNG BỘ
SELECT N'Hà Nội' AS ChiNhanh, idLai_Suat, rateLS FROM [SERVER_HN].[Techcombank_Site1_HN].[dbo].[LAISUAT] WHERE idLai_Suat = 'LS_01'
UNION ALL
SELECT N'Đà Nẵng' AS ChiNhanh, idLai_Suat, rateLS FROM [SERVER_DN].[Techcombank_Site2_DN].[dbo].[LAISUAT] WHERE idLai_Suat = 'LS_01'
UNION ALL
SELECT N'TP.HCM' AS ChiNhanh, idLai_Suat, rateLS FROM [SERVER_HCM].[Techcombank_Site3_HCM].[dbo].[LAISUAT] WHERE idLai_Suat = 'LS_01';


--- Câu 3:Distributed Stored Procedure-----------------------------------------------------------------------------------------------------

CREATE PROCEDURE sp_ChuyenTien_LienChiNhanh_KhepKin
    @idTK_Gui VARCHAR(20),  @idTK_Nhan VARCHAR(20), 
    @SoTien DECIMAL(18,2),  @NoiDung NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; 
    DECLARE @PhiGD DECIMAL(18,2) = 5500;
    BEGIN TRY
        -- 1. Kiểm tra số dư (Hà Nội)
        IF (SELECT balanceTK FROM [SERVER_HN].[Techcombank_Site1_HN].[dbo].[TAIKHOAN] WHERE idTai_Khoan = @idTK_Gui) < (@SoTien + @PhiGD)
        BEGIN
            PRINT N'Thất bại: Số dư không đủ.';
            RETURN;
        END
        -- 2. Thực hiện trừ tiền tại Hà Nội
        UPDATE [SERVER_HN].[Techcombank_Site1_HN].[dbo].[TAIKHOAN] 
        SET balanceTK = balanceTK - (@SoTien + @PhiGD) WHERE idTai_Khoan = @idTK_Gui;
        -- 3. Thực hiện cộng tiền tại TP.HCM
        UPDATE [SERVER_HCM].[Techcombank_Site3_HCM].[dbo].[TAIKHOAN] 
        SET balanceTK = balanceTK + @SoTien WHERE idTai_Khoan = @idTK_Nhan;
        PRINT N'Thành công: Giao dịch phân tán đã hoàn tất giữa Site HN và Site HCM.';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
-- Xem số dư tại Hà Nội (Người gửi) và TP.HCM (Người nhận)
SELECT N'Hà Nội (Gửi)' AS Site, idTai_Khoan, balanceTK 
FROM [SERVER_HN].[Techcombank_Site1_HN].[dbo].[TAIKHOAN] 
WHERE idTai_Khoan = 'TK_HN001';
SELECT N'TP.HCM (Nhận)' AS Site, idTai_Khoan, balanceTK 
FROM [SERVER_HCM].[Techcombank_Site3_HCM].[dbo].[TAIKHOAN] 
WHERE idTai_Khoan = 'TK_HCM001';

-- Thực hiện chuyển 1,000,000 VNĐ
EXEC sp_ChuyenTien_LienChiNhanh_KhepKin 
    @idTK_Gui = 'TK_HN001', 
    @idTK_Nhan = 'TK_HCM001', 
    @SoTien = 1000000, 
    @NoiDung = N'Chuyen tien hoc phi';

