CREATE OR REPLACE PROCEDURE PROC_KIEM_TRA_QUYEN (MA_NHAN_VIEN CHAR, ACTION_NAME CHAR, CONTROLLER_NAME CHAR, return_value OUT INT) AS
CHUC_VU CHAR(5);
BEGIN
    SELECT CHUCVU INTO CHUC_VU FROM NHANVIEN WHERE MANHANVIEN = MA_NHAN_VIEN;
    IF((CONTROLLER_NAME = 'Kho' AND CHUC_VU = 'CV001') OR (CONTROLLER_NAME = 'Kho' AND CHUC_VU = 'CV006')) THEN 
        RETURN_VALUE := 0;
        DBMS_OUTPUT.put_line(1);
    ELSIF((CONTROLLER_NAME = 'DoanhThu' AND CHUC_VU = 'CV001') OR (CONTROLLER_NAME = 'DoanhThu' AND CHUC_VU = 'CV003')) THEN
        RETURN_VALUE := 0;
    ELSIF((CONTROLLER_NAME = 'NhanSu' AND CHUC_VU = 'CV001') OR (CONTROLLER_NAME = 'NhanSu' AND CHUC_VU = 'CV007')) THEN
        RETURN_VALUE := 0;
    ELSIF((CONTROLLER_NAME = 'KhachHang' AND CHUC_VU = 'CV001') OR (CONTROLLER_NAME = 'KhachHang' AND CHUC_VU = 'CV009')) THEN
        RETURN_VALUE := 0;
    ELSIF((CONTROLLER_NAME = 'PhanHoi' AND CHUC_VU = 'CV001') OR (CONTROLLER_NAME = 'PhanHoi' AND CHUC_VU = 'CV009')) THEN
        RETURN_VALUE := 0;
    ELSIF((CONTROLLER_NAME = 'DonHang' AND CHUC_VU = 'CV001') OR (CONTROLLER_NAME = 'DonHang' AND CHUC_VU = 'CV005')) THEN
        RETURN_VALUE := 0;
    ELSIF((CONTROLLER_NAME = 'SanPham' AND CHUC_VU = 'CV001') OR (CONTROLLER_NAME = 'SanPham' AND CHUC_VU = 'CV008')) THEN
        RETURN_VALUE := 0;
    ELSIF(CONTROLLER_NAME = 'PhienTruyCap') THEN
        RETURN_VALUE := 0;
    ELSE
        RETURN_VALUE := -1;
    END IF;
END;
---Proc Insert NCC---
CREATE OR REPLACE PROCEDURE Proc_Insert_NCC (ten_ncc NVARCHAR2, ma_so_thue CHAR, dia_chi VARCHAR2, return_value OUT INT) AS
check_ten NUMBER(1);
check_mst NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;   
    SELECT COUNT(MaNCC) INTO check_ten FROM NhaCungCap WHERE TenNCC = ten_ncc;
    SELECT COUNT(MaNCC) INTO check_mst FROM NhaCungCap WHERE MaSoThue = ma_so_thue;
    IF(check_ten > 0) THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_mst > 0) THEN
        return_value := 2;
        ROLLBACK;
    ELSE
        INSERT INTO NhaCungCap(TenNCC,MaSoThue,DiaChi)
        VALUES(ten_ncc,ma_so_thue,dia_chi);
        return_value := 0;
        COMMIT;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;


---Proc Update NCC---
CREATE OR REPLACE PROCEDURE Proc_Update_NCC (ma_ncc CHAR, ten_ncc NVARCHAR2, ma_so_thue CHAR, dia_chi VARCHAR2, return_value OUT INT) AS
check_mancc NUMBER(1) := 0;
check_ten NUMBER(1);
check_mst NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;   
    SELECT COUNT(MaNCC) INTO check_ten FROM NhaCungCap WHERE TenNCC = ten_ncc AND MaNCC != ma_ncc;
    SELECT COUNT(MaNCC) INTO check_mst FROM NhaCungCap WHERE MaSoThue = ma_so_thue AND MaNCC != ma_ncc;
    SELECT COUNT(MaNCC) INTO check_mancc FROM NhaCungCap WHERE MANCC = ma_ncc;
    IF(check_ten > 0) THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_mst > 0) THEN
        return_value := 2;
        ROLLBACK;
    ELSIF(check_mancc > 0) THEN
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
        UPDATE NhaCungCap SET TenNCC = ten_ncc, MaSoThue = ma_so_thue, DiaChi = dia_chi WHERE MaNCC = ma_ncc;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 3;
        ROLLBACK;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;
---Proc Delete NCC---
CREATE OR REPLACE PROCEDURE Proc_Delete_NCC (ma_ncc CHAR, return_value OUT INT) AS
check_ma NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;  
    SELECT COUNT(MaNCC) INTO check_ma FROM NhaCungCap WHERE MANCC = ma_ncc;
    IF(check_ma > 0) THEN      
        DELETE FROM NhaCungCap WHERE MaNCC = ma_ncc;
        COMMIT;
        return_value := 0;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;


------------------------------------------------------------------
---Proc Insert TP---
CREATE OR REPLACE PROCEDURE Proc_Insert_TP (ten_tp NVARCHAR2, return_value OUT INT) AS
check_ten NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MATHANHPHO) INTO check_ten FROM THANHPHO WHERE TENTHANHPHO = ten_tp;
    IF(check_ten > 0) THEN
        return_value := 1;
        ROLLBACK;
    ELSE
        INSERT INTO ThanhPho(TenThanhPho)
        VALUES(ten_tp);
        return_value := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;
---Proc Update NCC---
CREATE OR REPLACE PROCEDURE Proc_Update_TP (ma_tp CHAR, ten_tp NVARCHAR2, return_value OUT INT) AS
check_ma NUMBER(1);
check_ten NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaThanhPho) INTO check_ma FROM ThanhPho WHERE mathanhpho = ma_tp;
    SELECT COUNT(MATHANHPHO) INTO check_ten FROM THANHPHO WHERE TENTHANHPHO = ten_tp AND MATHANHPHO != ma_tp;
    IF(check_ten > 0) THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_ma > 0) THEN    
        UPDATE ThanhPho SET TenThanhPho = ten_tp WHERE MaThanhPho = ma_tp;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 2;
        ROLLBACK;
    END IF;  
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

---Proc Delete TP---
CREATE OR REPLACE PROCEDURE Proc_Delete_TP (ma_tp CHAR, return_value OUT INT) AS
check_tp NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;  
    SELECT COUNT(MaThanhPho) INTO check_tp FROM ThanhPho WHERE mathanhpho = ma_tp;
    IF(check_tp > 0) THEN       
        DELETE FROM ThanhPho WHERE MaThanhPho = ma_tp;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;  
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

------------------------------------------------------------------
---Proc Insert KhuyenMai---
CREATE OR REPLACE PROCEDURE Proc_Insert_Khuyen_Mai (ten_km NVARCHAR2, phan_tram_khuyen_mai FLOAT, ngay_bat_dau TIMESTAMP, ngay_ket_thuc TIMESTAMP, mo_ta NVARCHAR2, return_value OUT INT) AS
BEGIN
    IF(ngay_bat_dau < ngay_ket_thuc) THEN
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
        INSERT INTO KhuyenMai(TenKM,PhanTramKhuyenMai,NgayBatDau,NgayKetThuc,MoTa)
        VALUES(ten_km,phan_tram_khuyen_mai,ngay_bat_dau,ngay_ket_thuc,mo_ta);
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;
---Proc Update KhuyenMai---
CREATE OR REPLACE PROCEDURE Proc_Update_Khuyen_Mai (ma_km CHAR, ten_km NVARCHAR2, phan_tram_khuyen_mai FLOAT, ngay_bat_dau TIMESTAMP, ngay_ket_thuc TIMESTAMP, mo_ta NVARCHAR2, return_value OUT INT) AS
check_km NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;  
    SELECT COUNT(MAKHUYENMAI) INTO check_km FROM KHUYENMAI WHERE MAKHUYENMAI = ma_km;
    IF(ngay_bat_dau > ngay_ket_thuc) THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_km > 0) THEN     
        UPDATE KhuyenMai SET TenKM = ten_km, PhanTramKhuyenMai = phan_tram_khuyen_mai, ngaybatdau = ngay_bat_dau, ngayketthuc = ngay_ket_thuc, mota = mo_ta WHERE makhuyenmai = ma_km;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

---Proc Delete KhuyenMai---
CREATE OR REPLACE PROCEDURE Proc_Delete_Khuyen_Mai (ma_km CHAR, return_value OUT INT) AS
check_km NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MAKHUYENMAI) INTO check_km FROM KHUYENMAI WHERE MAKHUYENMAI = ma_km;
    IF(check_km > 0) THEN
        DELETE FROM KhuyenMai WHERE makhuyenmai = ma_km;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;  
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

-----------------------------------------------------------------

---Proc Insert DanhMuc---
CREATE OR REPLACE PROCEDURE Proc_Insert_Danh_Muc (ten_danh_muc NVARCHAR2, return_value OUT INT) AS
check_ten NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MADANHMUC) INTO check_ten FROM DANHMUC WHERE TENDANHMUC = ten_danh_muc;
    IF(check_ten > 0)THEN
        return_value := 1;
        ROLLBACK;
    ELSE
        INSERT INTO DanhMuc(TenDanhMuc)
        VALUES(ten_danh_muc);
        return_value := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;
---Proc Update DanhMuc---
CREATE OR REPLACE PROCEDURE Proc_Update_Danh_Muc (ma_danh_muc CHAR, ten_danh_muc NVARCHAR2, return_value OUT INT) AS
check_dm NUMBER(1);
check_ten NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MADANHMUC) INTO check_dm FROM DanhMuc WHERE MADANHMUC = ma_danh_muc;
    SELECT COUNT(MADANHMUC) INTO check_ten FROM DANHMUC WHERE TENDANHMUC = ten_danh_muc AND MADANHMUC != ma_danh_muc;
    IF(check_ten > 0)THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_dm > 0) THEN
        UPDATE DanhMuc SET TenDanhMuc = ten_danh_muc WHERE MaDanhMuc = ma_danh_muc;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

---Proc Delete DanhMuc---
CREATE OR REPLACE PROCEDURE Proc_Delete_Danh_Muc (ma_danh_muc CHAR, return_value OUT INT) AS
check_dm NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MADANHMUC) INTO check_dm FROM DanhMuc WHERE MADANHMUC = ma_danh_muc;
    IF(check_dm > 0) THEN
        DELETE FROM DanhMuc WHERE MaDanhMuc = ma_danh_muc;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

EXECUTE Proc_Insert_Danh_Muc('Tủ lạnh - Tủ mát - Tủ đông');
EXECUTE Proc_Insert_Danh_Muc('Laptop - PC - Máy in - Phụ kiệ');
EXECUTE Proc_Insert_Danh_Muc('Tivi - loa - dàn âm thanh');
EXECUTE Proc_Insert_Danh_Muc('Test');
EXECUTE Proc_Update_Danh_Muc('DM004','Test2');
EXECUTE Proc_Delete_Danh_Muc('DM004');

SELECT * FROM DanhMuc;

------------------------------------------------------------------

---Proc Insert Loai---
CREATE OR REPLACE PROCEDURE Proc_Insert_Loai (ma_danh_muc CHAR, ten_loai NVARCHAR2, return_value OUT INT) AS
check_ten NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MALOAI) INTO check_ten FROM LOAI WHERE TENLOAI = ten_loai AND MADANHMUC = ma_danh_muc;
    IF(check_ten > 0)THEN
        return_value := 1;
        ROLLBACK;
    ELSE
        INSERT INTO Loai(MaDanhMuc,TenLoai)
        VALUES(ma_danh_muc,ten_loai);
        return_value := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;
---Proc Update Loai---
CREATE OR REPLACE PROCEDURE Proc_Update_Loai (ma_loai CHAR, ma_danh_muc CHAR, ten_loai NVARCHAR2, return_value OUT INT) AS
check_ten NUMBER(1);
check_ma NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaLoai) INTO check_ma FROM Loai WHERE MaLoai = ma_loai;
    SELECT COUNT(MALOAI) INTO check_ten FROM LOAI WHERE TENLOAI = ten_loai AND MADANHMUC = ma_danh_muc AND MaLoai != ma_loai;
    IF(check_ten > 0)THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_ma > 0) THEN
        UPDATE Loai SET MaDanhMuc = ma_danh_muc, TenLoai = ten_loai WHERE MaLoai = ma_loai;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

---Proc Delete Loai---
CREATE OR REPLACE PROCEDURE Proc_Delete_Loai (ma_loai CHAR, return_value OUT INT) AS
check_loai NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaLoai) INTO check_loai FROM Loai WHERE MaLoai = ma_loai;
    IF(check_loai > 0) THEN
        DELETE FROM Loai WHERE MaLoai = ma_loai;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

-----------------------------------------------------------------

-----------------------------------------------------------------

---Proc Insert SanPham---
CREATE OR REPLACE PROCEDURE Proc_Insert_San_Pham (ten_san_pham NVARCHAR2, anh_minh_hoa VARCHAR, don_gia DECIMAL, khuyen_mai CHAR, return_value OUT INT) AS
check_ten NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MASANPHAM) INTO check_ten FROM SANPHAM WHERE TENSANPHAM = ten_san_pham;
    IF(check_ten > 0)THEN
        return_value := 1;
        ROLLBACK;
    ELSE
        INSERT INTO SanPham(TenSanPham,AnhMinhHoa,DonGia,MaKhuyenMai,TrangThai)
        VALUES(ten_san_pham,anh_minh_hoa,don_gia,khuyen_mai,0);
        return_value := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;
---Proc Update SanPham---
CREATE OR REPLACE PROCEDURE Proc_Update_San_Pham (ma_san_pham CHAR, ten_san_pham NVARCHAR2, anh_minh_hoa VARCHAR, don_gia DECIMAL, khuyen_mai CHAR, trang_thai CHAR, return_value OUT INT) AS
check_ma NUMBER(1);
check_ten NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO check_ma FROM SanPham WHERE MaSanPham = ma_san_pham;
    SELECT COUNT(MASANPHAM) INTO check_ten FROM SANPHAM WHERE TENSANPHAM = ten_san_pham AND MASANPHAM != ma_san_pham;
    IF(check_ten > 0)THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_ma > 0) THEN
        UPDATE SanPham SET TenSanPham = ten_san_pham, AnhMinhHoa = anh_minh_hoa, DonGia = don_gia,MaKhuyenMai = khuyen_mai, TRANGTHAI = TRANG_THAI WHERE MaSanPham = ma_san_pham;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;
---Proc Delete SanPham---
CREATE OR REPLACE PROCEDURE Proc_Delete_San_Pham (ma_san_pham CHAR, return_value OUT INT) AS
check_sp NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO check_sp FROM SanPham WHERE MaSanPham = ma_san_pham;
    IF(check_sp > 0) THEN
        DELETE FROM SanPham WHERE MaSanPham = ma_san_pham;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        return_value := -1;
END;

------------------------------------------------------------------

---Proc Insert ChiTietLoai---
CREATE OR REPLACE PROCEDURE Proc_Insert_ChiTiet_Loai (ma_sp CHAR, ma_loai CHAR, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SELECT COUNT(MASANPHAM) INTO CHECK_PK FROM CHITIETLOAI WHERE MASANPHAM = MA_SP AND MALOAI = MA_LOAI;
    IF(CHECK_PK > 0) THEN
        return_value := 1;
        ROLLBACK;
    ELSE
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
        INSERT INTO ChiTietLoai(MaSanPham,MaLoai)
        VALUES(ma_sp, ma_loai);
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update ChiTietLoai---
CREATE OR REPLACE PROCEDURE Proc_Update_ChiTiet_Loai (ma_sp CHAR, ma_loai_cu CHAR, ma_loai_moi CHAR, return_value OUT INT) AS
check_pk_cu NUMBER(1);
check_pk_moi NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO check_pk_cu FROM CHITIETLOAI WHERE MaSanPham = ma_sp AND MALOAI = MA_LOAI_CU;
    SELECT COUNT(MaSanPham) INTO check_pk_moi FROM CHITIETLOAI WHERE MaSanPham = ma_sp AND MALOAI = ma_loai_moi AND MALOAI != MA_LOAI_CU;
    IF(CHECK_PK_MOI > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(check_pk_cu > 0) THEN
        UPDATE ChiTietLoai SET MaLoai = ma_loai_moi WHERE MaSanPham = ma_sp AND MaLoai = ma_loai_cu;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete ChiTietLoai---
CREATE OR REPLACE PROCEDURE Proc_Delete_ChiTiet_Loai (ma_sp CHAR, ma_loai CHAR, return_value OUT INT) AS
check_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO check_PK FROM CHITIETLOAI WHERE MaSanPham = ma_sp AND MALOAI = MA_LOAI;
    IF(check_PK > 0) THEN
        DELETE FROM ChiTietLoai WHERE MaSanPham = ma_sp AND MaLoai = ma_loai; 
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

-----------------------------------------------------------------

---Proc Insert TinhNang---
CREATE OR REPLACE PROCEDURE Proc_Insert_Tinh_Nang (ma_sp CHAR, ten_tinh_nang NVARCHAR2, mo_ta NVARCHAR2, hinh_anh VARCHAR, return_value OUT INT) AS
CHECK_TEN NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MASANPHAM) INTO CHECK_TEN FROM TINHNANG WHERE MASANPHAM = MA_SP AND TENTINHNANG = TEN_TINH_NANG;
    IF(CHECK_TEN > 0)THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSE
        INSERT INTO TinhNang(MaSanPham,TenTinhNang,MoTa,HinhAnh)
        VALUES(ma_sp, ten_tinh_nang, mo_ta, hinh_anh);
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Update TinhNang---
CREATE OR REPLACE PROCEDURE Proc_Update_Tinh_Nang (ma_sp CHAR, ten_tinh_nang_cu NVARCHAR2, ten_tinh_nang_MOI NVARCHAR2, mo_ta NVARCHAR2, hinh_anh VARCHAR, return_value OUT INT) AS
CHECK_PK NUMBER(1);
CHECK_TEN NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO CHECK_PK FROM TinhNang WHERE MaSanPham = ma_sp AND TenTinhNang = ten_tinh_nang_cu;
    SELECT COUNT(MaSanPham) INTO CHECK_TEN FROM TinhNang WHERE MaSanPham = ma_sp AND TenTinhNang = ten_tinh_nang_MOI AND TENTINHNANG != TEN_TINH_NANG_CU;
    IF(CHECK_TEN > 0)THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_PK > 0) THEN
        UPDATE TinhNang SET TenTinhNang = ten_tinh_nang_MOI, MoTa = mo_ta, HinhAnh = hinh_anh WHERE MaSanPham = ma_sp AND TenTinhNang = ten_tinh_nang_cu;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete TinhNang---
CREATE OR REPLACE PROCEDURE Proc_Delete_Tinh_Nang (ma_sp CHAR, ten_tinh_nang NVARCHAR2, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO CHECK_PK FROM TinhNang WHERE MaSanPham = ma_sp AND TenTinhNang = ten_tinh_nang;
    IF(CHECK_PK > 0) THEN
        DELETE FROM TinhNang WHERE MaSanPham = ma_sp AND TenTinhNang = ten_tinh_nang;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

------------------------------------------------------------------

---Proc Insert DacDiemNoiBat---
CREATE OR REPLACE PROCEDURE Proc_Insert_Dac_Diem (ma_sp CHAR, ten_dac_diem NVARCHAR2, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MASANPHAM) INTO CHECK_PK FROM DACDIEMNOIBAT WHERE MASANPHAM = MA_SP AND TENDACDIEM = TEN_DAC_DIEM;
    IF(CHECK_PK > 0)THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSE
        INSERT INTO DacDiemNoiBat(MaSanPham,TenDacDiem)
        VALUES(ma_sp, ten_dac_diem);
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update DacDiem---
CREATE OR REPLACE PROCEDURE Proc_Update_Dac_Diem (ma_sp CHAR, ten_dac_diem_cu NVARCHAR2, ten_dac_diem_MOI NVARCHAR2, return_value OUT INT) AS
check_PK NUMBER(1);
check_TEN NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO check_PK FROM DacDiemNoiBat WHERE MaSanPham = ma_sp AND TenDacDiem = ten_dac_diem_cu;
    SELECT COUNT(MaSanPham) INTO check_TEN FROM DacDiemNoiBat WHERE MaSanPham = ma_sp AND TenDacDiem = ten_dac_diem_MOI AND TENDACDIEM != TEN_DAC_DIEM_CU;
    IF(CHECK_TEN > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(check_PK > 0) THEN
        UPDATE DacDiemNoiBat SET TenDacDiem = ten_dac_diem_MOI WHERE MaSanPham = ma_sp AND TenDacDiem = ten_dac_diem_cu;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete DacDiem---
CREATE OR REPLACE PROCEDURE Proc_Delete_Dac_Diem (ma_sp CHAR, ten_dac_diem NVARCHAR2, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO CHECK_PK FROM DacDiemNoiBat WHERE MaSanPham = ma_sp AND TenDacDiem = ten_dac_diem;
    IF(CHECK_PK > 0) THEN
        DELETE FROM DacDiemNoiBat WHERE MaSanPham = ma_sp AND TenDacDiem = ten_dac_diem;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

------------------------------------------------------------------

---Proc Insert ThongSoKiThuat---
CREATE OR REPLACE PROCEDURE Proc_Insert_Thong_So (ma_sp CHAR, ten_thong_so NVARCHAR2, mo_ta NVARCHAR2, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MASANPHAM) INTO CHECK_PK FROM THONGSOKITHUAT WHERE MASANPHAM = MA_SP AND TENTHONGSO = TEN_THONG_SO;
    IF(CHECK_PK > 0)THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSE
        INSERT INTO ThongSoKiThuat(MaSanPham,TenThongSo,MoTa)
        VALUES(ma_sp, ten_thong_so, mo_ta);
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update ThongSoKiThuat---
CREATE OR REPLACE PROCEDURE Proc_Update_Thong_So (ma_sp CHAR, ten_thong_so_cu NVARCHAR2, ten_thong_so_MOI NVARCHAR2, mo_ta NVARCHAR2, return_value OUT INT) AS
CHECK_PK NUMBER(1);
CHECK_TEN NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO CHECK_PK FROM ThongSoKiThuat WHERE MaSanPham = ma_sp AND TenThongSo = ten_thong_so_cu;
    SELECT COUNT(MaSanPham) INTO CHECK_TEN FROM ThongSoKiThuat WHERE MaSanPham = ma_sp AND TenThongSo = ten_thong_so_MOI AND TENTHONGSO != TEN_THONG_SO_CU;
    IF(CHECK_TEN > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_PK > 0) THEN
        UPDATE ThongSoKiThuat SET TenThongSo = ten_thong_so_MOI, MoTa = mo_ta WHERE MaSanPham = ma_sp AND TenThongSo = ten_thong_so_cu;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete ThongSoKiThuat---
CREATE OR REPLACE PROCEDURE Proc_Delete_Thong_So (ma_sp CHAR, ten_thong_so NVARCHAR2, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaSanPham) INTO CHECK_PK FROM ThongSoKiThuat WHERE MaSanPham = ma_sp AND TenThongSo = ten_thong_so;
    IF(CHECK_PK > 0) THEN
        DELETE FROM ThongSoKiThuat WHERE MaSanPham = ma_sp AND TenThongSo = ten_thong_so;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

------------------------------------------------------------------

---Proc Insert ChucVu---
CREATE OR REPLACE PROCEDURE Proc_Insert_Chuc_Vu (ten_chuc_vu NVARCHAR2, return_value OUT INT) AS
CHECK_TEN NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MACHUCVU) INTO CHECK_TEN FROM CHUCVU WHERE TENCHUCVU = TEN_CHUC_VU;
    IF(CHECK_TEN > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSE
        INSERT INTO ChucVu(TenChucVu)
        VALUES(ten_chuc_vu);
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update ChucVu---
CREATE OR REPLACE PROCEDURE Proc_Update_Chuc_Vu (ma_chuc_vu CHAR, ten_chuc_vu NVARCHAR2, return_value OUT INT) AS
CHECK_PK NUMBER(1);
CHECK_TEN NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaChucVu) INTO CHECK_PK FROM ChucVu WHERE MaChucVu = ma_chuc_vu;
    SELECT COUNT(MaChucVu) INTO CHECK_TEN FROM ChucVu WHERE TENCHUCVU = TEN_CHUC_VU AND MACHUCVU != MA_CHUC_VU;
    IF(CHECK_TEN > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_PK > 0) THEN
        UPDATE ChucVu SET TenChucVu = ten_chuc_vu WHERE MaChucVu = ma_chuc_vu;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete ChucVu---
CREATE OR REPLACE PROCEDURE Proc_Delete_Chuc_Vu (ma_chuc_vu CHAR, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaChucVu) INTO CHECK_PK FROM ChucVu WHERE MaChucVu = ma_chuc_vu;
    IF(CHECK_PK > 0) THEN
        DELETE FROM ChucVu WHERE MaChucVu = ma_chuc_vu;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


------------------------------------------------------------------

---Proc Insert CuaHang---
CREATE OR REPLACE PROCEDURE Proc_Insert_Cua_Hang (dia_chi NVARCHAR2, thanh_pho CHAR, cua_hang_truong CHAR, ngay_thanh_lap TIMESTAMP, return_value OUT INT) AS
CHECK_DC NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;    
    SELECT COUNT(MACUAHANG) INTO CHECK_DC FROM CUAHANG WHERE DIACHI = DIA_CHI;
    IF(CHECK_DC > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSE
        INSERT INTO CuaHang(DiaChi,ThanhPho,CuaHangTruong,NgayThanhLap)
        VALUES(dia_chi,thanh_pho,cua_hang_truong,ngay_thanh_lap);    
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update CuaHang---
CREATE OR REPLACE PROCEDURE Proc_Update_Cua_Hang (ma_cua_hang CHAR, dia_chi NVARCHAR2, thanh_pho CHAR, cua_hang_truong CHAR, ngay_thanh_lap TIMESTAMP, return_value OUT INT) AS
CHECK_PK NUMBER(1);
CHECK_DC NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaCuaHang) INTO CHECK_PK FROM CuaHang WHERE MaCuaHang = ma_cua_hang;
    SELECT COUNT(MaCuaHang) INTO CHECK_DC FROM CuaHang WHERE DIACHI = DIA_CHI AND MaCuaHang != ma_cua_hang;
    IF(CHECK_DC > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_PK > 0) THEN
        UPDATE CuaHang SET DiaChi = dia_chi, ThanhPho = thanh_pho, CuaHangTruong = cua_hang_truong, NgayThanhLap = ngay_thanh_lap WHERE MaCuaHang = ma_cua_hang;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete CuaHang---
CREATE OR REPLACE PROCEDURE Proc_Delete_Cua_Hang (ma_cua_hang CHAR, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaCuaHang) INTO CHECK_PK FROM CuaHang WHERE MaCuaHang = ma_cua_hang;
    IF(CHECK_PK > 0) THEN
        DELETE FROM CuaHang WHERE MaCuaHang = ma_cua_hang;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


-----------------------------------------------------------------
---Proc Insert NhanVien---
CREATE OR REPLACE PROCEDURE Proc_Insert_Nhan_Vien (ten_nv NVARCHAR2, ngay_sinh TIMESTAMP, s_dt CHAR, e_mail CHAR, dia_chi NVARCHAR2, gioi_tinh CHAR, chuc_vu CHAR, cua_hang CHAR, hinh_thuc CHAR, tai_khoan CHAR, mat_khau CHAR, trang_thai CHAR, return_value OUT INT) AS
CHECK_SDT NUMBER(1);
CHECK_EMAIL NUMBER(1);
CHECK_TK NUMBER(1);
CHECK_USER_IN_SERVER INT := 0;
USER_NAME VARCHAR2(50);
EXE_STRING   VARCHAR2 (1000);
DEFAULT_PASS VARCHAR2(50) := '123456';
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SELECT COUNT(MANHANVIEN) INTO CHECK_SDT FROM NAMVU.NHANVIEN WHERE SDT = S_DT;
    SELECT COUNT(MANHANVIEN) INTO CHECK_EMAIL FROM NAMVU.NHANVIEN WHERE EMAIL = E_MAIL;
    SELECT COUNT(MANHANVIEN) INTO CHECK_TK FROM NAMVU.NHANVIEN WHERE TAIKHOAN = TAI_KHOAN;
    IF(CHECK_SDT > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_EMAIL > 0) THEN
        RETURN_VALUE := 2;
        ROLLBACK;
    ELSIF(CHECK_TK > 0) THEN
        RETURN_VALUE := 3;
        ROLLBACK;
    ELSE
        INSERT INTO NAMVU.NHANVIEN(TenNhanVien,NgaySinh,SDT,Email,DiaChi,GioiTinh,ChucVu,CuaHang,HinhThuc,TaiKhoan,MatKhau,TrangThai)
        VALUES(ten_nv,ngay_sinh,s_dt,e_mail,dia_chi,gioi_tinh,chuc_vu,cua_hang,hinh_thuc,tai_khoan,mat_khau,trang_thai); 
        USER_NAME := UPPER(TRIM(TAI_KHOAN));
        SELECT COUNT (1) INTO CHECK_USER_IN_SERVER FROM SYS.dba_users WHERE username = USER_NAME;
        
        EXE_STRING := 'alter session set "_oracle_script"=TRUE ';
        EXECUTE IMMEDIATE ( EXE_STRING ); 
        IF CHECK_USER_IN_SERVER != 0 THEN
            EXE_STRING := 'DROP USER '|| TRIM(USER_NAME) || ' CASCADE';      	
            EXECUTE IMMEDIATE ( EXE_STRING );
        END IF;
        EXE_STRING := 'CREATE USER ' || TRIM(USER_NAME) || ' IDENTIFIED BY ' || TRIM(DEFAULT_PASS) || ' DEFAULT TABLESPACE SYSTEM';       
        EXECUTE IMMEDIATE ( EXE_STRING ); 
       
        ---CHECK CHUC VU VA GRANT ROLE CHO TAI KHOAN O SERVER
        IF(CHUC_VU = 'CV001') THEN
            EXE_STRING := 'GRANT QUANTRIVIEN TO ' || USER_NAME;
        ELSIF(CHUC_VU = 'CV002') THEN
                EXE_STRING := 'GRANT QUANLYCUAHANG TO' || USER_NAME;
        ELSIF(CHUC_VU = 'CV003') THEN
            EXE_STRING := 'GRANT KETOAN TO ' || USER_NAME;
        ELSIF(CHUC_VU = 'CV004') THEN
            EXE_STRING := 'GRANT THUNGAN TO ' || USER_NAME;
        ELSIF(CHUC_VU = 'CV005') THEN
            EXE_STRING := 'GRANT NHANVIEN TO ' || USER_NAME;
        ELSIF(CHUC_VU = 'CV006') THEN
            EXE_STRING := 'GRANT TRUONGKHO TO ' || USER_NAME;
        ELSIF(CHUC_VU = 'CV007') THEN
            EXE_STRING := 'GRANT NHANSU TO ' || USER_NAME;
        ELSIF(CHUC_VU = 'CV008') THEN
            EXE_STRING := 'GRANT QUANLYSANPHAM TO ' || USER_NAME;
        ELSIF(CHUC_VU = 'CV009') THEN
            EXE_STRING := 'GRANT CSKH TO ' || USER_NAME;
        END IF;
        EXECUTE IMMEDIATE ( EXE_STRING );
        EXE_STRING := 'alter session set "_oracle_script"=FALSE ';
        EXECUTE IMMEDIATE ( EXE_STRING ); 
        COMMIT;
        RETURN_VALUE := 0;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Update NhanVien---
CREATE OR REPLACE PROCEDURE Proc_Update_Nhan_Vien (ma_nhan_vien CHAR, ten_nv NVARCHAR2, ngay_sinh TIMESTAMP, s_dt CHAR, e_mail CHAR, dia_chi NVARCHAR2, gioi_tinh CHAR, chuc_vu CHAR, cua_hang CHAR, hinh_thuc CHAR, tai_khoan CHAR, mat_khau CHAR, trang_thai CHAR, return_value OUT INT) AS
CHECK_PK NUMBER(1);
CHECK_SDT NUMBER(1);
CHECK_EMAIL NUMBER(1);
CHECK_TK NUMBER(1);
CHECK_USER_IN_SERVER INT := 0;
USER_NAME VARCHAR2(50);
EXE_STRING   VARCHAR2 (1000);
GET_ROLE_IN_SERVER VARCHAR2(100);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaNhanVien) INTO CHECK_PK FROM NhanVien WHERE MaNhanVien = TRIM(MA_NHAN_VIEN);
    SELECT COUNT(MANHANVIEN) INTO CHECK_SDT FROM NHANVIEN WHERE SDT = S_DT AND MaNhanVien != TRIM(ma_nhan_vien);
    SELECT COUNT(MANHANVIEN) INTO CHECK_EMAIL FROM NHANVIEN WHERE EMAIL = E_MAIL AND MaNhanVien != TRIM(ma_nhan_vien);
    SELECT COUNT(MANHANVIEN) INTO CHECK_TK FROM NHANVIEN WHERE TAIKHOAN = TAI_KHOAN AND MaNhanVien != TRIM(ma_nhan_vien);
    IF(CHECK_SDT > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_EMAIL > 0) THEN
        RETURN_VALUE := 2;
        ROLLBACK;
    ELSIF(CHECK_TK > 0) THEN
        RETURN_VALUE := 3;
        ROLLBACK;
    ELSIF(CHECK_PK > 0) THEN
        UPDATE NhanVien SET TenNhanVien = TRIM(ten_nv), NgaySinh = ngay_sinh, SDT = s_dt, Email = TRIM(e_mail), DiaChi = TRIM(dia_chi),GioiTinh = gioi_tinh, ChucVu = TRIM(chuc_vu), CuaHang = TRIM(cua_hang), HinhThuc = hinh_thuc, TaiKhoan = TRIM(tai_khoan), MatKhau = TRIM(mat_khau), TrangThai = trang_thai WHERE MaNhanVien = TRIM(ma_nhan_vien);
        USER_NAME := UPPER(TRIM(TAI_KHOAN));
        EXE_STRING := 'alter session set "_oracle_script"=TRUE ';
        EXECUTE IMMEDIATE ( EXE_STRING ); 
        ---KIEM TRA TRANG THAI
        SELECT GRANTED_ROLE INTO GET_ROLE_IN_SERVER FROM "SYS"."DBA_ROLE_PRIVS" WHERE GRANTEE = USER_NAME; 
        IF(TRANG_THAI = 1) THEN ---NEU = 1 LAY LAI ROLE
            ---CHECK TAI KHOAN O SERVER
            SELECT COUNT (1) INTO CHECK_USER_IN_SERVER FROM dba_users WHERE username = USER_NAME;
            IF CHECK_USER_IN_SERVER != 0 THEN
                EXE_STRING := 'REVOKE ' || GET_ROLE_IN_SERVER || ' FROM '|| USER_NAME;      	
                EXECUTE IMMEDIATE ( EXE_STRING );
            END IF;            
        ELSE ---NEU = 0 LAY LAI ROLE VA CAP ROLE MOI
            EXE_STRING := 'REVOKE ' || GET_ROLE_IN_SERVER || ' FROM '|| USER_NAME;      	
            EXECUTE IMMEDIATE ( EXE_STRING );     
            
            ---CHECK CHUC VU VA GRANT ROLE CHO TAI KHOAN O SERVER
            IF(CHUC_VU = 'CV001') THEN
                EXE_STRING := 'GRANT QUANTRIVIEN TO ' || USER_NAME;
            ELSIF(CHUC_VU = 'CV002') THEN
                    EXE_STRING := 'GRANT QUANLYCUAHANG TO' || USER_NAME;
            ELSIF(CHUC_VU = 'CV003') THEN
                EXE_STRING := 'GRANT KETOAN TO ' || USER_NAME;
            ELSIF(CHUC_VU = 'CV004') THEN
                EXE_STRING := 'GRANT THUNGAN TO ' || USER_NAME;
            ELSIF(CHUC_VU = 'CV005') THEN
                EXE_STRING := 'GRANT NHANVIEN TO ' || USER_NAME;
            ELSIF(CHUC_VU = 'CV006') THEN
                EXE_STRING := 'GRANT TRUONGKHO TO ' || USER_NAME;
            ELSIF(CHUC_VU = 'CV007') THEN
                EXE_STRING := 'GRANT NHANSU TO ' || USER_NAME;
            ELSIF(CHUC_VU = 'CV008') THEN
                EXE_STRING := 'GRANT QUANLYSANPHAM TO ' || USER_NAME;
            ELSIF(CHUC_VU = 'CV009') THEN
                EXE_STRING := 'GRANT CSKH TO ' || USER_NAME;
            END IF;
            EXECUTE IMMEDIATE ( EXE_STRING );
        END IF;
        EXE_STRING := 'alter session set "_oracle_script"=FALSE ';
        EXECUTE IMMEDIATE ( EXE_STRING ); 
        COMMIT;
        RETURN_VALUE := 0;
    ELSE
        RETURN_VALUE := 4;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        RETURN_VALUE := -1;
END;


---Proc DELETE NhanVien---
CREATE OR REPLACE PROCEDURE Proc_Delete_Nhan_Vien (ma_nhan_vien CHAR, return_value OUT INT) AS
CHECK_PK NUMBER(1);
CHECK_USER_IN_SERVER INT := 0;
USER_NAME VARCHAR2(50);
EXE_STRING VARCHAR2 (1000);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaNhanVien) INTO CHECK_PK FROM NhanVien WHERE MaNhanVien = ma_nhan_vien;
    IF(CHECK_PK > 0) THEN
        SELECT TAIKHOAN INTO USER_NAME FROM NHANVIEN WHERE MANHANVIEN = ma_nhan_vien;
        DELETE FROM NhanVien WHERE MaNhanVien = ma_nhan_vien;
        EXE_STRING := 'alter session set "_oracle_script"=TRUE ';
        EXECUTE IMMEDIATE ( EXE_STRING ); 
        ---CHECK TAI KHOAN O SERVER
        SELECT COUNT (1) INTO CHECK_USER_IN_SERVER FROM dba_users WHERE username = USER_NAME;
        IF CHECK_USER_IN_SERVER != 0 THEN
            EXE_STRING := 'DROP USER '|| USER_NAME || ' CASCADE';   	
            EXECUTE IMMEDIATE ( EXE_STRING );
        END IF;
        EXE_STRING := 'alter session set "_oracle_script"=FALSE ';
        EXECUTE IMMEDIATE ( EXE_STRING ); 
        COMMIT;
        RETURN_VALUE := 0;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

-----------------------------------------------------------------
---Proc Insert Kho---
CREATE OR REPLACE PROCEDURE Proc_Insert_Kho (ma_cua_hang CHAR, truong_kho CHAR, dia_chi NVARCHAR2, return_value OUT INT) AS
CHECK_TRUONG_KHO_AVA NUMBER(1);
check_truong_kho NUMBER(1);
check_DC NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaNhanVien) INTO check_truong_kho FROM NhanVien WHERE MaNhanVien = truong_kho AND CuaHang = ma_cua_hang AND ChucVu = 'CV006' AND TrangThai = '0';  
    SELECT COUNT(MAKHO) INTO check_DC FROM KHO WHERE DIACHI = DIA_CHI;
    SELECT COUNT(MAKHO) INTO CHECK_TRUONG_KHO_AVA FROM KHO WHERE TRUONGKHO = TRUONG_KHO;
    IF(check_truong_kho > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_DC > 0) THEN
        RETURN_VALUE := 2;
        ROLLBACK;
    ELSIF(CHECK_TRUONG_KHO_AVA > 0) THEN  
        RETURN_VALUE := 3;
        ROLLBACK;
    ELSE
        INSERT INTO Kho(MaCuaHang,TruongKho,DiaChi)
        VALUES(ma_cua_hang, truong_kho, dia_chi);
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update Kho---
CREATE OR REPLACE PROCEDURE Proc_Update_Kho (ma_kho CHAR, ma_cua_hang CHAR, truong_kho CHAR, dia_chi NVARCHAR2, return_value OUT INT) AS
CHECK_PK NUMBER(1);
CHECK_TRUONG_KHO_AVA NUMBER(1);
check_truong_kho NUMBER(1);
check_DC NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaKho) INTO CHECK_PK FROM Kho WHERE MaKho = ma_kho;
    SELECT COUNT(MAKHO) INTO CHECK_TRUONG_KHO_AVA FROM KHO WHERE TRUONGKHO = TRUONG_KHO AND MAKHO != MA_KHO;
    SELECT COUNT(MaNhanVien) INTO check_truong_kho FROM NhanVien WHERE MaNhanVien = truong_kho AND CuaHang = ma_cua_hang AND ChucVu = 'CV006' AND TrangThai = '0';
    SELECT COUNT(MAKHO) INTO check_DC FROM KHO WHERE DIACHI = DIA_CHI AND MAKHO != MA_KHO;
    IF(check_truong_kho = 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_DC > 0) THEN
        RETURN_VALUE := 2;
        ROLLBACK;
    ELSIF(CHECK_TRUONG_KHO_AVA > 0) THEN  
        RETURN_VALUE := 3;
        ROLLBACK;
    ELSIF(CHECK_PK > 0) THEN
        UPDATE Kho SET MaCuaHang = ma_cua_hang, TruongKho = truong_kho, DiaChi = dia_chi WHERE MaKho = ma_kho;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 4;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete Kho---
CREATE OR REPLACE PROCEDURE Proc_Delete_Kho (ma_kho CHAR, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaKho) INTO CHECK_PK FROM Kho WHERE MaKho = ma_kho;
    IF(CHECK_PK > 0) THEN
        DELETE FROM Kho WHERE MaKho = ma_kho;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


------------------------------------------------------------------

---Proc Insert ChiTietKho---
CREATE OR REPLACE PROCEDURE Proc_Insert_ChiTiet_Kho (ma_kho CHAR, ma_san_pham CHAR, so_luong INT, return_value OUT INT) AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    IF(so_luong < 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSE
        INSERT INTO ChiTietKho(MaKho,MaSanPham,SoLuong)
        VALUES(ma_kho,ma_san_pham,so_luong);  
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update ChiTietKho---
CREATE OR REPLACE PROCEDURE Proc_Update_ChiTiet_Kho (ma_kho CHAR, ma_san_pham CHAR, so_luong INT, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MAKHO) INTO CHECK_PK FROM CHITIETKHO WHERE MAKHO = MA_KHO AND MASANPHAM = MA_SAN_PHAM;
    IF(so_luong < 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_PK > 0) THEN   
        UPDATE ChiTietKho SET SoLuong = so_luong WHERE MaKho = ma_kho AND MaSanPham = ma_san_pham;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete ChiTietKho---
CREATE OR REPLACE PROCEDURE Proc_Delete_ChiTiet_Kho (ma_kho CHAR, ma_san_pham CHAR, return_value OUT INT) AS
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MAKHO) INTO CHECK_PK FROM CHITIETKHO WHERE MAKHO = MA_KHO AND MASANPHAM = MA_SAN_PHAM;
    IF(CHECK_PK > 0) THEN   
        DELETE FROM ChiTietKho WHERE MaKho = ma_kho AND MaSanPham = ma_san_pham;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


------------------------------------------------------------------

---Proc Insert PhieuNhap---
CREATE OR REPLACE PROCEDURE Proc_Insert_Phieu_Nhap (nha_cung_cap IN CHAR, nhan_vien_truc_kho IN CHAR, ma_kho IN CHAR, tong_gia_tri DECIMAL, ma_pn OUT CHAR, return_value OUT INT) AS
dem_pn NUMBER;
CHECK_NCC NUMBER(1);
CHECK_NV NUMBER(1);
CHECK_KHO NUMBER(1);
CHECK_TRUNG NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
        SELECT COUNT(MANCC) INTO CHECK_NCC FROM NHACUNGCAP WHERE MANCC = NHA_CUNG_CAP;
        SELECT COUNT(MANHANVIEN) INTO CHECK_NV FROM NHANVIEN WHERE MANHANVIEN = nhan_vien_truc_kho;
        SELECT COUNT(MAKHO) INTO CHECK_KHO FROM KHO WHERE MAKHO = ma_kho;
        IF(CHECK_NCC = 0) THEN
            RETURN_VALUE := 1;
        ELSIF(CHECK_NV = 0) THEN
            RETURN_VALUE := 2;
        ELSIF(CHECK_KHO = 0) THEN
            RETURN_VALUE := 3;
        ELSE
            SELECT COUNT(MACUAHANG) INTO CHECK_TRUNG FROM NHANVIEN nv, KHO k WHERE MANHANVIEN = nhan_vien_truc_kho AND MAKHO = ma_kho AND nv.CUAHANG = k.MACUAHANG;
            IF(CHECK_TRUNG > 0) THEN
                SELECT COUNT(MaPhieuNhap) + 1 INTO dem_pn FROM PhieuNhap;
                INSERT INTO PhieuNhap(MaPhieuNhap,NhaCungCap,NhanVienTrucKho,MaKho,ThoiGianTao,TongGiaTri,TrangThai)
                VALUES(TO_CHAR(dem_pn),nha_cung_cap,nhan_vien_truc_kho,ma_kho,CURRENT_DATE,tong_gia_tri,0);
                SELECT MaPhieuNhap INTO ma_pn FROM PhieuNhap ORDER BY MaPhieuNhap DESC FETCH FIRST 1 ROW ONLY;
                RETURN_VALUE := 0;
                COMMIT;
            ELSE
                RETURN_VALUE := 4;
            END IF;
        END IF; 
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

CREATE OR REPLACE PROCEDURE Proc_Insert_ChiTiet_Phieu_Nhap (ma_phieu_nhap IN CHAR, ma_san_pham IN CHAR, so_luong INT, don_gia_nhap DECIMAL, return_value OUT INT) AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    IF(SO_LUONG > 0 AND DON_GIA_NHAP > 0) THEN
        INSERT INTO ChiTietPhieuNhap(MaPhieuNhap,MaSanPham,SoLuong,DonGiaNhap)
        VALUES(ma_phieu_nhap,ma_san_pham,so_luong,don_gia_nhap);
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

------------------------------------------------------------------

---Proc Insert Dang Ky Khach Hang---
CREATE OR REPLACE PROCEDURE Proc_Dang_Ky_Khach_Hang (ten_khach_hang CHAR, s_dt CHAR, dia_chi CHAR, thanh_pho CHAR, e_mail CHAR, tai_khoan char, mat_khau char, return_value OUT INT) AS
check_sdt NUMBER(1);
check_email NUMBER(1);
check_tk NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaKhachHang) INTO check_sdt FROM KhachHang WHERE SDT = s_dt;
    SELECT COUNT(MaKhachHang) INTO check_email FROM KhachHang WHERE EMAIL = e_mail;
    SELECT COUNT(MaKhachHang) INTO check_tk FROM KhachHang WHERE TAIKHOAN = tai_khoan;
    IF(check_sdt > 0) THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_email > 0) THEN
        return_value := 2;
        ROLLBACK;
    ELSIF(check_tk > 0) THEN
        return_value := 3;
        ROLLBACK;
    ELSE
        INSERT INTO KhachHang(TenKhachHang,SDT,DiaChi,ThanhPho,Email,TaiKhoan,MatKhau,TrangThai) VALUES(ten_khach_hang,s_dt,dia_chi,thanh_pho,e_mail,tai_khoan,mat_khau,0);
        return_value := 0;
        COMMIT;    
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


---Proc Insert Dang Nhap---
CREATE OR REPLACE PROCEDURE Proc_Dang_Nhap (tai_khoan CHAR, mat_khau CHAR, LOAI INT, return_value OUT INT, return_id OUT CHAR) AS
check_tk NUMBER(1);
check_mk CHAR(100);
BEGIN
    IF(LOAI = 0) THEN
        SELECT COUNT(MaKhachHang) INTO check_tk FROM KhachHang WHERE TAIKHOAN = tai_khoan;
        IF(check_tk > 0) THEN
            SELECT MatKhau INTO check_mk FROM KhachHang WHERE TaiKhoan = tai_khoan;
            IF(check_mk = mat_khau) THEN
                return_value := 0;
                SELECT MaKhachHang INTO return_id FROM KhachHang WHERE TaiKhoan = tai_khoan;
            ELSE
                return_value := 2;
                return_id := NULL;
            END IF;
        ELSE
            return_value := 1;
            return_id := NULL;
        END IF;
    ELSIF(LOAI = 1) THEN
        SELECT COUNT(MANHANVIEN) INTO check_tk FROM NHANVIEN WHERE TAIKHOAN = tai_khoan;
        IF(check_tk > 0) THEN
            SELECT MatKhau INTO check_mk FROM NHANVIEN WHERE TaiKhoan = tai_khoan;
            IF(check_mk = mat_khau) THEN
                return_value := 0;
                SELECT MANHANVIEN INTO return_id FROM NHANVIEN WHERE TaiKhoan = tai_khoan;
            ELSE
                return_value := 2;
                return_id := NULL;
            END IF;
        ELSE
            return_value := 1;
            return_id := NULL;
        END IF;
    ELSE
        RETURN_VALUE := 3;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        RETURN_VALUE := -1;
END;

---Proc Update thong tin khach hang---
CREATE OR REPLACE PROCEDURE Proc_Update_Khach_Hang (ma_khach_hang CHAR,ten_khach_hang NVARCHAR2, s_dt CHAR, dia_chi NVARCHAR2, thanh_pho CHAR, e_mail CHAR, return_value OUT INT) AS
check_sdt NUMBER(1);
check_email NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaKhachHang) INTO check_sdt FROM KhachHang WHERE SDT = s_dt AND MAKHACHHANG != MA_KHACH_HANG;
    SELECT COUNT(MaKhachHang) INTO check_email FROM KhachHang WHERE EMAIL = e_mail AND MAKHACHHANG != MA_KHACH_HANG;
    IF(check_sdt > 0) THEN
        return_value := 1;
        ROLLBACK;
    ELSIF(check_email > 0) THEN
        return_value := 2;
        ROLLBACK;
    ELSE
        UPDATE KhachHang SET TenKhachHang = ten_khach_hang, SDT = s_dt, DiaChi = dia_chi, ThanhPho = thanh_pho, Email = e_mail WHERE MaKhachHang = ma_khach_hang;
        return_value := 0;
        COMMIT;    
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc UPDATE TINH TRANG khach hang---
CREATE OR REPLACE PROCEDURE Proc_UPDATE_TINH_TRANG_Khach_Hang (ma_khach_hang CHAR,TRANG_THAI CHAR, return_value OUT INT) AS
check_kh NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaKhachHang) INTO check_kh FROM KhachHang WHERE MAKHACHHANG = MA_KHACH_HANG;
    IF(check_kh > 0) THEN
        UPDATE KhachHang SET TRANGTHAI = TRANG_THAI WHERE MaKhachHang = ma_khach_hang;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        return_value := 1;   
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc doi mat khau---
CREATE OR REPLACE PROCEDURE Proc_Doi_Mat_Khau (E_MAIL CHAR, LOAI INT, mat_khau_moi CHAR, return_value OUT INT) AS
check_email NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    IF(LOAI = 0) THEN
        SELECT COUNT(MAKHACHHANG) INTO check_email FROM KhachHang WHERE EMAIL = E_MAIL;
        IF(check_email > 0) THEN  
            UPDATE KhachHang SET MatKhau = mat_khau_moi WHERE EMAIL = E_MAIL;
            return_value := 0;
            COMMIT;    
        ELSE
            return_value := 1;
            ROLLBACK;
        END IF;
    ELSIF(LOAI = 1) THEN
        SELECT COUNT(MANHANVIEN) INTO check_email FROM NHANVIEN WHERE EMAIL = E_MAIL;
        IF(check_email > 0) THEN  
            UPDATE NHANVIEN SET MatKhau = mat_khau_moi WHERE EMAIL = E_MAIL;
            return_value := 0;
            COMMIT;    
        ELSE
            return_value := 1;
            ROLLBACK;
        END IF;
    ELSE
        return_value := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


---Proc check_email---
CREATE OR REPLACE PROCEDURE Proc_Kiem_Tra_Email_Khach_Hang (e_mail CHAR, return_value OUT INT) AS
check_email NUMBER(1);
BEGIN
    SELECT Count(MaKhachHang) INTO check_email FROM KhachHang WHERE Email = e_mail;
    IF(check_email > 0) THEN  
        return_value := 0; 
    ELSE
        return_value := 1;
    END IF;
END;

------------------------------------------------------------------

---Proc Insert Voucher---
CREATE OR REPLACE PROCEDURE Proc_Insert_Voucher (ma_voucher CHAR, ten_voucher NVARCHAR2, phan_tram_khuyen_mai FLOAT, ngay_bat_dau TIMESTAMP, ngay_ket_thuc TIMESTAMP, mo_ta NVARCHAR2, return_value OUT INT) AS
check_vc NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaVoucher) INTO check_vc FROM VOUCHER WHERE MaVoucher = ma_voucher;
    IF(check_vc > 0) THEN  
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(NGAY_BAT_DAU > NGAY_KET_THUC) THEN
        RETURN_VALUE := 2;
        ROLLBACK;
    ELSE
        INSERT INTO Voucher(MaVoucher , TenVoucher, PhanTramKhuyenMai, NgayBatDau, NgayKetThuc, MoTa)
        VALUES(ma_voucher, ten_voucher, phan_tram_khuyen_mai, ngay_bat_dau, ngay_ket_thuc, mo_ta);  
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update Voucher---
CREATE OR REPLACE PROCEDURE Proc_Update_Voucher (ma_voucher CHAR, ten_voucher NVARCHAR2, phan_tram_khuyen_mai FLOAT, ngay_bat_dau TIMESTAMP, ngay_ket_thuc TIMESTAMP, mo_ta NVARCHAR2, return_value OUT INT) AS
check_vc NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaVoucher) INTO check_vc FROM VOUCHER WHERE MaVoucher = ma_voucher;
    IF(NGAY_BAT_DAU > NGAY_KET_THUC) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(check_vc > 0) THEN  
        UPDATE Voucher SET TenVoucher =  ten_voucher, PhanTramKhuyenMai = phan_tram_khuyen_mai, NgayBatDau = ngay_bat_dau, NgayKetThuc = ngay_ket_thuc, MoTa = mo_ta WHERE MaVoucher = ma_voucher;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete Voucher---
CREATE OR REPLACE PROCEDURE Proc_Delete_Voucher (ma_voucher CHAR, return_value OUT INT) AS
check_vc NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaVoucher) INTO check_vc FROM VOUCHER WHERE MaVoucher = ma_voucher;
    IF(check_vc > 0) THEN
        DELETE FROM Voucher WHERE MaVoucher = ma_voucher;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Gui Phan Hoi---
CREATE OR REPLACE PROCEDURE Proc_Gui_Phan_Hoi (ma_khach_hang CHAR, noi_dung NVARCHAR2, return_value OUT INT) AS
check_ph NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaPhanHoi) INTO check_ph FROM PhanHoi WHERE MaKhachHang = ma_khach_hang AND TrangThai = '1';
    IF(check_ph > 4) THEN  
        return_value := 1;
        ROLLBACK;
    ELSE
        INSERT INTO PhanHoi(MaKhachHang, NoiDung, TrangThai)
        VALUES(ma_khach_hang, noi_dung,1);    
        return_value := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Xu Ly Phan Hoi---
CREATE OR REPLACE PROCEDURE Proc_Xu_Ly_Phan_Hoi (ma_phan_hoi CHAR, return_value OUT INT) AS
check_ph NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaPhanHoi) INTO check_ph FROM PhanHoi WHERE MaPhanHoi = ma_phan_hoi;
    IF(check_ph > 0) THEN  
        UPDATE Phanhoi SET TrangThai = 0 WHERE MaPhanHoi = ma_phan_hoi;
        return_value := 0;
        COMMIT;
    ELSE
        return_value := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

------------------------------------------------------------------

---Proc Insert HangTichDiem---
CREATE OR REPLACE PROCEDURE Proc_Insert_Hang_Tich_Diem (ten_hang NVARCHAR2, return_value OUT INT) AS
CHECK_TEN NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaHang) INTO CHECK_TEN FROM HangTichDiem WHERE Tenhang = ten_hang;
    IF(CHECK_TEN > 0) THEN  
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSE
        INSERT INTO HangTichDiem(TenHang)
        VALUES(ten_hang);
        RETURN_VALUE := 0;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;
---Proc Update HangTichDiem---
CREATE OR REPLACE PROCEDURE Proc_Update_Hang_Tich_Diem (ma_hang CHAR, ten_hang NVARCHAR2, return_value OUT INT) AS
CHECK_TEN NUMBER(1);
CHECK_PK NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaHang) INTO CHECK_TEN FROM HangTichDiem WHERE TENHANG = ten_hang AND MAHANG != MA_HANG;
    SELECT COUNT(MaHang) INTO CHECK_PK FROM HangTichDiem WHERE MaHang = ma_hang;
    IF(CHECK_TEN > 0) THEN
        RETURN_VALUE := 1;
        ROLLBACK;
    ELSIF(CHECK_PK > 0) THEN  
        UPDATE HangTichDiem SET TenHang =  ten_hang WHERE MaHang = ma_hang;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 2;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;

---Proc Delete HangTichDiem---
CREATE OR REPLACE PROCEDURE Proc_Delete_Hang_Tich_Diem (ma_hang CHAR, return_value OUT INT) AS
check_hang NUMBER(1);
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaHang) INTO check_hang FROM HangTichDiem WHERE MaHang = ma_hang;
    IF(check_hang > 0) THEN
        DELETE FROM HangTichDiem WHERE MaHang = ma_hang;
        RETURN_VALUE := 0;
        COMMIT;
    ELSE
        RETURN_VALUE := 1;
        ROLLBACK;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


CREATE OR REPLACE PROCEDURE Proc_Tao_The_Cho_Khach_Hang (ma_khach_hang CHAR, return_value OUT INT) AS
check_kh NUMBER;
dem_the NUMBER;
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    SELECT COUNT(MaKhachHang) INTO check_kh FROM KhachHang WHERE MaKhachHang = ma_khach_hang;
    IF(check_kh > 0) THEN
        SELECT COUNT(MaThe) INTO dem_the FROM TheTichDiem WHERE MaKhachHang = ma_khach_hang;
        IF(dem_the > 0) THEN 
            return_value := 1;
        ELSE
            INSERT INTO TheTichDiem(MaThe,MaKhachHang,Hang,NgayTao,Diem,TrangThai) VALUES('1',ma_khach_hang,'H0001',CURRENT_DATE,0,0);
            return_value := 0;
            COMMIT;
        END IF;
    ELSE
        return_value := 2;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


---Proc tạo đơn hàng online---
CREATE OR REPLACE PROCEDURE Proc_Tao_Don_Hang (ma_khach_hang IN CHAR, MA_CUA_HANG CHAR, ma_voucher IN CHAR, tong_gia_tri_don IN DECIMAL, ma_don OUT CHAR, return_value OUT INT) IS
check_kh NUMBER;
ngay_bd TIMESTAMP;
ngay_kt TIMESTAMP;
DEMDH NUMBER;
ID CHAR(10);
CHUOISOKHONG VARCHAR(8) := '0';
I NUMBER := 0;
DEMID NUMBER;
LENGTHID NUMBER;
   BEGIN
    ---if input is not null
    IF ma_khach_hang IS NOT NULL AND MA_CUA_HANG IS NOT NULL AND tong_gia_tri_don IS NOT NULL THEN
        ---check ma khach hang
        SELECT COUNT(MaKhachHang) INTO check_kh FROM KhachHang WHERE MaKhachHang = ma_khach_hang;
        ---neu ma khach hang khong ton tai
        IF(check_kh = 0) THEN
            RETURN_VALUE := 3;
        ---neu co voucher
        ELSIF ma_voucher IS NOT NULL THEN
            SELECT NgayBatDau INTO ngay_bd FROM VOUCHER WHERE MaVoucher = ma_voucher;
            SELECT NgayKetThuc INTO ngay_kt FROM VOUCHER WHERE MaVoucher = ma_voucher;
            ---kiem tra voucher con date khong
            IF (ngay_bd > CURRENT_DATE OR ngay_kt < CURRENT_DATE) THEN
                RETURN_VALUE := 2;
            END IF;---end check date voucher
        END IF;
        
        IF(RETURN_VALUE > 0)THEN
            MA_DON := NULL;
        ELSE
            SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
            SELECT COUNT(MaDonHang)INTO DEMDH FROM DonHang;
            DEMDH := DEMDH +  1;
            LENGTHID := (10 - ((LENGTH(DEMDH) + LENGTH('DH'))));
            WHILE(I < LENGTHID - 1)
            LOOP
                CHUOISOKHONG := CONCAT(CHUOISOKHONG,'0');
                I := I + 1;
            END LOOP;
            ID := CONCAT('DH',CHUOISOKHONG||DEMDH);
            SELECT COUNT(MaDonHang) INTO DEMID FROM DonHang WHERE MaDonHang = ID;
            WHILE(DEMID <> 0)
            LOOP
                DEMDH := DEMDH + 1;
                CHUOISOKHONG := '0';
                I := 0;
                LENGTHID := 10 - ((LENGTH(DEMDH) + LENGTH('DH')));
                WHILE (I < LENGTHID - 1)
                LOOP
                     CHUOISOKHONG := CONCAT(CHUOISOKHONG,'0');
                    I := I + 1;
                END LOOP;
                ID := CONCAT('DH',CHUOISOKHONG||DEMDH);
                SELECT COUNT(MaDonHang) INTO DEMID FROM DonHang WHERE MaDonHang = ID;
            END LOOP;
            INSERT INTO DonHang(MaDonHang,NhanVienPhuTrach,MaKhachHang,MaCuaHang,ThoiGianTao,MaVoucher,Loai,TinhTrangXacNhan,TinhTrangThanhToan,TinhTrangGiaoHang,TongGiaTri)
            VALUES(ID,null,ma_khach_hang,ma_cua_hang,CURRENT_DATE,ma_voucher,0,null,null,null,tong_gia_tri_don);
            ma_don := ID;
            RETURN_VALUE := 0;
            COMMIT;
        END IF;      
    ELSE
        RETURN_VALUE := 1;
    END IF;---end neu input not null
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK; 
        RETURN_VALUE := -1; 
   END;



---THEM CHI TIET DON HANG
CREATE OR REPLACE PROCEDURE Proc_Them_Chi_Tiet_Don_Hang (ma_don_hang IN CHAR, MA_SAN_PHAM CHAR, SO_LUONG IN INT, DON_GIA IN DECIMAL, THANH_TIEN IN DECIMAL, return_value OUT INT) IS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
    INSERT INTO ChiTietDonHang(MaDonHang,MaSanPham,SoLuong,DonGia,ThanhTien)VALUES(MA_DON_HANG,MA_SAN_PHAM,SO_LUONG,DON_GIA,THANH_TIEN);
    COMMIT;
    RETURN_VALUE := 0;
    EXCEPTION 
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;
END;


---Proc xác nhận đơn hàng---
CREATE OR REPLACE PROCEDURE Proc_Xac_Nhan_Don_Hang (ma_don_hang IN CHAR, ma_nhan_vien IN CHAR, tinh_trang_xac_nhan IN CHAR, return_value OUT INT) IS
tinh_trang_hien_tai CHAR(1);
   BEGIN
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
            ---kiem tra tinh trang hien tai
            SELECT TinhTrangXacNhan INTO tinh_trang_hien_tai FROM DonHang WHERE MaDonHang = ma_don_hang;
            ---neu tinh trang xac nhan input la true
            IF(tinh_trang_hien_tai IS NULL AND ma_don_hang IS NOT NULL AND ma_nhan_vien IS NOT NULL and tinh_trang_xac_nhan = '0') THEN
                UPDATE DonHang SET TinhTrangXacNhan = tinh_trang_xac_nhan, NhanVienPhuTrach = ma_nhan_vien WHERE MaDonHang = ma_don_hang;
                RETURN_VALUE := 0;
                COMMIT;
                ---neu tinh trang xac nhan input la false
            ELSIF(tinh_trang_hien_tai IS NULL AND ma_don_hang IS NOT NULL AND ma_nhan_vien IS NOT NULL and tinh_trang_xac_nhan = '1') THEN
                UPDATE DonHang SET TinhTrangXacNhan = tinh_trang_xac_nhan, TinhTrangThanhToan = tinh_trang_xac_nhan, 
                TinhTrangGiaoHang = tinh_trang_xac_nhan, NhanVienPhuTrach = ma_nhan_vien WHERE MaDonHang = ma_don_hang;
                RETURN_VALUE := 0;
                COMMIT;
            ELSE
                RETURN_VALUE := 1;
                ROLLBACK;
            END IF;---end kiem tra
        EXCEPTION
            WHEN OTHERS THEN 
            ROLLBACK;
            RETURN_VALUE := -1;
   END;
   
---Proc thanh toán đơn hàng---
CREATE OR REPLACE PROCEDURE Proc_Thanh_Toan_Don_Hang (ma_don_hang IN CHAR, ma_nhan_vien IN CHAR, tinh_trang_thanh_toan IN CHAR, return_value OUT INT) IS
tinh_trang_hien_tai CHAR(1);
   BEGIN
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
            ---kiem tra tinh trang hien tai
            SELECT TinhTrangThanhToan INTO tinh_trang_hien_tai FROM DonHang WHERE MaDonHang = ma_don_hang;
            ---neu tinh trang xac nhan input la true
            IF(tinh_trang_hien_tai IS NULL AND ma_don_hang IS NOT NULL AND ma_nhan_vien IS NOT NULL and tinh_trang_thanh_toan = '0') THEN
                UPDATE DonHang SET TinhTrangThanhToan = tinh_trang_thanh_toan, NhanVienPhuTrach = ma_nhan_vien WHERE MaDonHang = ma_don_hang;
                RETURN_VALUE := 0;
                COMMIT;
                ---neu tinh trang xac nhan input la false
            ELSIF(tinh_trang_hien_tai IS NULL AND ma_don_hang IS NOT NULL AND ma_nhan_vien IS NOT NULL and tinh_trang_thanh_toan = '1') THEN
                UPDATE DonHang SET TinhTrangThanhToan = tinh_trang_thanh_toan, 
                TinhTrangGiaoHang = tinh_trang_thanh_toan, NhanVienPhuTrach = ma_nhan_vien WHERE MaDonHang = ma_don_hang;
                UPDATE PHIEUXUAT SET TRANGTHAI = 1 WHERE MADONHANG = MA_DON_HANG;
                RETURN_VALUE := 0;
                COMMIT;
            ELSE
                RETURN_VALUE := 1;
                ROLLBACK;
            END IF;---end kiem tra
        EXCEPTION
            WHEN OTHERS THEN 
            ROLLBACK;
            RETURN_VALUE := -1;
   END;
   


---Proc xuất kho va phieu bao hanh---
CREATE OR REPLACE PROCEDURE Proc_Xuat_Phieu_Xuat_Va_Bao_Hanh (nhan_vien_tao_phieu IN CHAR, ma_don_hang IN CHAR, return_value OUT INT) IS
---declare bien kiem tra
CHECK_TINH_TRANG NUMBER(1);
check_phieu NUMBER := 0;
ma_cua_hang CHAR(5);
count_kho NUMBER;
---declare flag
flag_stop_cursor NUMBER := 1;
flag_commit NUMBER := 1;
---declare bien tam chi tiet kho
dem NUMBER;
dem_px NUMBER := -1;
ma_sp CHAR(10);
sl NUMBER;
check_sl NUMBER;
---declare ma
ma_kho CHAR(5);
truong_kho CHAR(10);
ma_px CHAR(10);
ma_khach_hang CHAR(10);
---declare cursor
c_dh_sp CHAR(10); 
c_dh_sl NUMBER; 
c_dh_dongia DECIMAL;
CURSOR c_ctdh is SELECT MaSanPham, SoLuong, DonGia FROM ChiTietDonHang WHERE MaDonHang = ma_don_hang;
---declare cursor
c_dh_sp2 CHAR(10); 
c_dh_sl2 NUMBER; 
CURSOR c_ctdh2 is SELECT MaSanPham, SoLuong FROM ChiTietDonHang WHERE MaDonHang = ma_don_hang;
BEGIN
    ---kiem tra input
    IF NHAN_VIEN_TAO_PHIEU IS NOT NULL AND MA_DON_HANG IS NOT NULL THEN
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
            SELECT COUNT(MADONHANG) INTO CHECK_TINH_TRANG FROM DONHANG WHERE MADONHANG = MA_DON_HANG AND TINHTRANGXACNHAN = 0;
            IF(CHECK_TINH_TRANG > 0) THEN
                SELECT COUNT (MaPhieuXuat) INTO CHECK_PHIEU FROM PhieuXuat where MaDonHang = ma_don_hang;
                IF(CHECK_PHIEU > 0) THEN
                    RETURN_VALUE := 3;
                ELSE    
                    ---lay ma cua hang
                    SELECT MaCuaHang INTO ma_cua_hang FROM DonHang WHERE MaDonHang = ma_don_hang;
                    ---dem xem cua hang co may kho
                    SELECT COUNT(MaKho) INTO count_kho FROM Kho WHERE MaCuaHang = ma_cua_hang;
                    ---mo cursor duyet tung san pham trong don hang
                    OPEN c_ctdh; 
                    LOOP 
                    FETCH c_ctdh into c_dh_sp, c_dh_sl, c_dh_dongia; 
                        EXIT WHEN c_ctdh%notfound OR flag_stop_cursor = 0;                  
                        ---voi moi san pham trong don hang
                        ---duyet tung kho  
                        dem := 1;
                            WHILE dem <= count_kho
                            LOOP     
                                SELECT MaKho INTO ma_kho FROM (SELECT ROWNUM AS STT, k.MaKho FROM Kho k WHERE k.MaCuaHang = ma_cua_hang) WHERE STT = dem;
                                SELECT COUNT(SoLuong) INTO check_sl FROM ChiTietKho WHERE MaKho = ma_kho AND MaSanPham = c_dh_sp;
                                IF check_sl = 0 THEN
                                    --khong lam gi ca, kiem tra kho tiep theo
                                    dem := dem + 1;
                                    ELSE--- neu so luong > 0(kho nay co san pham do)
                                    ---lay so luong ra kiem tra
                                    SELECT SoLuong INTO sl FROM ChiTietKho WHERE MaKho = ma_kho AND MaSanPham = c_dh_sp;
                                    IF(c_dh_sl <= sl) THEN---neu so luong trong kho du thi
                                        ---kiem tra xem co phieu xuat cho kho nay o don hang nay chua
                                        SELECT COUNT (MaPhieuXuat) INTO check_phieu FROM PhieuXuat where MaDonHang = ma_don_hang and MaKho = ma_kho;
                                        SELECT TruongKho INTO truong_kho FROM Kho WHERE MaKho = ma_kho;
                                        IF check_phieu = 0 THEN---chua co phieu thi 
                                            ---dem px
                                            IF dem_px = -1 THEN SELECT COUNT(MaPhieuXuat) + 1 INTO dem_px FROM PhieuXuat;
                                            ELSE
                                                dem_px := dem_px + 1;
                                            END IF;---end dem px
                                            INSERT INTO PhieuXuat(MaPhieuXuat,NhanVienTaoPhieu,NhanVienTruongKho,MaKho,MaDonHang,ThoiGianTao,TongGiaTri,TrangThai) 
                                            VALUES(TO_CHAR(dem_px),nhan_vien_tao_phieu,truong_kho,ma_kho,ma_don_hang,CURRENT_DATE,0,0);
                                            UPDATE ChiTietKho SET SoLuong = SoLuong - c_dh_sl WHERE MaKho = ma_kho AND MaSanPham = c_dh_sp;                                  
                                            SELECT MaPhieuXuat INTO ma_px FROM PhieuXuat WHERE MaDonHang = ma_don_hang AND MaKho = ma_kho;
                                            INSERT INTO ChiTietPhieuXuat(MaPhieuXuat,MaSanPham,SoLuong)VALUES(ma_px,c_dh_sp,c_dh_sl);
                                            UPDATE PhieuXuat SET TongGiaTri = TongGiaTri + (c_dh_sl * c_dh_dongia) WHERE MaPhieuXuat = ma_px;
                                            c_dh_sl := 0;
                                        ELSE
                                            SELECT MaPhieuXuat INTO ma_px FROM PhieuXuat WHERE MaDonHang = ma_don_hang AND MaKho = ma_kho;
                                            UPDATE ChiTietKho SET SoLuong = SoLuong - c_dh_sl WHERE MaKho = ma_kho AND MaSanPham = c_dh_sp;    
                                            INSERT INTO ChiTietPhieuXuat(MaPhieuXuat,MaSanPham,SoLuong)VALUES(ma_px,c_dh_sp,c_dh_sl);
                                            UPDATE PhieuXuat SET TongGiaTri = TongGiaTri + (c_dh_sl * c_dh_dongia) WHERE MaPhieuXuat = ma_px;
                                            c_dh_sl := 0;
                                        END IF; ---end check phieu
                                        dem := count_kho;
                                    ELSE---neu so luong trong kho khong du thi
                                        ---van kiem tra nhu tren
                                        ---kiem tra xem co phieu xuat cho kho nay o don hang nay chua
                                        SELECT COUNT (MaPhieuXuat) INTO check_phieu FROM PhieuXuat where MaDonHang = ma_don_hang and MaKho = ma_kho;
                                        SELECT TruongKho INTO truong_kho FROM Kho WHERE MaKho = ma_kho;
                                        IF check_phieu = 0 THEN---chua co phieu thi 
                                            IF dem_px = -1 THEN SELECT COUNT(MaPhieuXuat) + 1 INTO dem_px FROM PhieuXuat;
                                            ELSE
                                                dem_px := dem_px + 1;
                                            END IF;---end dem px
                                            INSERT INTO PhieuXuat(MaPhieuXuat,NhanVienTaoPhieu,NhanVienTruongKho,MaKho,MaDonHang,ThoiGianTao,TongGiaTri,TrangThai) 
                                            VALUES(TO_CHAR(dem_px),nhan_vien_tao_phieu,truong_kho,ma_kho,ma_don_hang,CURRENT_DATE,0,0);
                                            ---Cap nhat lai so luong con thieu
                                            c_dh_sl := c_dh_sl - sl;
                                            ---Cap nhat lai so luong kho = 0
                                            UPDATE ChiTietKho SET SoLuong = 0 WHERE MaKho = ma_kho AND MaSanPham = c_dh_sp;                                      
                                            SELECT MaPhieuXuat INTO ma_px FROM PhieuXuat WHERE MaDonHang = ma_don_hang AND MaKho = ma_kho;
                                            INSERT INTO ChiTietPhieuXuat(MaPhieuXuat,MaSanPham,SoLuong)VALUES(ma_px,c_dh_sp,sl);
                                            UPDATE PhieuXuat SET TongGiaTri = TongGiaTri + (sl * c_dh_dongia) WHERE MaPhieuXuat = ma_px;
                                        ELSE
                                            SELECT MaPhieuXuat INTO ma_px FROM PhieuXuat WHERE MaDonHang = ma_don_hang AND MaKho = ma_kho;
                                            ---Cap nhat lai so luong con thieu
                                            c_dh_sl := c_dh_sl - sl;
                                            UPDATE ChiTietKho SET SoLuong = 0 WHERE MaKho = ma_kho AND MaSanPham = c_dh_sp;  
                                            INSERT INTO ChiTietPhieuXuat(MaPhieuXuat,MaSanPham,SoLuong)VALUES(ma_px,c_dh_sp,sl);
                                            UPDATE PhieuXuat SET TongGiaTri = TongGiaTri + (sl * c_dh_dongia) WHERE MaPhieuXuat = ma_px;
                                        END IF; ---end check phieu
                                    END IF;---end kiem tra so luong kho
                                END IF;---end so luong is null       
                                IF (c_dh_sl > 0 and dem = count_kho) THEN ---con hang, het kho
                                    flag_stop_cursor := 0;
                                ELSIF (c_dh_sl > 0 and dem < count_kho) THEN ---con hang, con kho
                                    dem := dem + 1;
                                ELSE   ---het hang, het kho hoac con kho
                                    dem := count_kho + 1;
                                END IF;
                            END LOOP;           
                    END LOOP; 
                    CLOSE c_ctdh;
                        
                    ---CHECK FLAG STOP CURSOR
                    IF flag_stop_cursor = 0 THEN
                        ROLLBACK;
                        RETURN_VALUE := 4;
                    ELSIF FLAG_STOP_CURSOR = 1 THEN
                        ---mo cursor
                        SELECT MaKhachHang INTO ma_khach_hang FROM DonHang WHERE MaDonHang = ma_don_hang;
                        OPEN c_ctdh2; 
                        LOOP 
                        FETCH c_ctdh2 into c_dh_sp2, c_dh_sl2; 
                            EXIT WHEN c_ctdh2%notfound;
                            WHILE c_dh_sl2 > 0
                            LOOP
                                INSERT INTO PhieuBaoHanh(MaSanPham,MaKhachHang,MaDonHang,NgayTao,NgayHetHan,TrangThai)
                                VALUES(c_dh_sp,ma_khach_hang,ma_don_hang,CURRENT_DATE,ADD_MONTHS(CURRENT_DATE,12),0);
                                c_dh_sl2 := c_dh_sl2 - 1;
                            END LOOP;
                        END LOOP; 
                        FLAG_COMMIT := 0;
                    END IF;
                        
                    ---CHECK FLAG COMMIT
                    IF(FLAG_COMMIT = 0) THEN
                        COMMIT;
                        RETURN_VALUE := 0;
                    END IF;
                END IF;
            ELSE
                RETURN_VALUE := 2;
            END IF;
    ELSE
        RETURN_VALUE := 1;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN
        ROLLBACK;
        RETURN_VALUE := -1;
END;


---Proc tình trạng giao hàng---
CREATE OR REPLACE PROCEDURE Proc_Tinh_Trang_Giao_Hang (ma_don_hang IN CHAR, ma_nhan_vien IN CHAR, tinh_trang_giao_hang IN CHAR, RETURN_VALUE OUT INT) IS
---check
CHECK_TRANG_THAI NUMBER(1);
CHECK_PX NUMBER(1);
CHECK_THE NUMBER(1);
---FLAG
FLAG_COMMIT NUMBER(1) := 1;
---ma
ma_khach_hang CHAR(10);
ma_the CHAR(10);
get_ma_kho CHAR(5);
--tongtiendon va diem
tong_gia_tri DECIMAL(18,2);
tong_diem NUMBER(38);
BEGIN
    IF(MA_DON_HANG IS NOT NULL AND MA_NHAN_VIEN IS NOT NULL AND TINH_TRANG_GIAO_HANG IS NOT NULL) THEN
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
            ---kiem tra tinh trang hien tai
            SELECT COUNT(MADONHANG) INTO CHECK_TRANG_THAI FROM DonHang WHERE MaDonHang = ma_don_hang AND TINHTRANGXACNHAN = 0 AND TINHTRANGTHANHTOAN = 0 AND TINHTRANGGIAOHANG IS NULL;
            ---kiem tra xem xuat kho chua
            SELECT COUNT(MaPhieuXuat) INTO CHECK_PX FROM PhieuXuat WHERE MaDonHang = ma_don_hang;
            IF(CHECK_TRANG_THAI = 0) THEN
                RETURN_VALUE := 2;
            ELSIF(CHECK_PX = 0) THEN
                RETURN_VALUE := 3;
            ELSE
                IF(tinh_trang_giao_hang = '0') THEN
                    UPDATE DonHang SET TinhTrangGiaoHang = '0', NhanVienPhuTrach = ma_nhan_vien WHERE MaDonHang = ma_don_hang;
                    SELECT MaKhachHang INTO ma_khach_hang FROM DonHang WHERE MaDonHang = ma_don_hang;
                    SELECT COUNT(MaThe) INTO CHECK_THE FROM TheTichDiem WHERE MaKhachHang = ma_khach_hang;
                    ---kiem tra co the khong
                    IF(CHECK_THE > 0) THEN 
                        SELECT MaThe INTO ma_the FROM TheTichDiem WHERE MaKhachHang = ma_khach_hang;
                        SELECT TongGiaTri INTO tong_gia_tri FROM DonHang WHERE MaDonHang = ma_don_hang;
                        UPDATE TheTichDiem SET Diem = Diem + (tong_gia_tri / 1000) WHERE MaThe = ma_the;
                        SELECT Diem INTO tong_diem FROM TheTichDiem WHERE MaThe = ma_the;
                        ---if xep hang
                        IF tong_diem >= 5000 AND tong_diem < 20000 THEN 
                            UPDATE TheTichDiem SET Hang = 'H0002' WHERE MaThe = ma_the;
                        ELSE IF tong_diem >= 20000 AND tong_diem < 50000 THEN 
                            UPDATE TheTichDiem SET Hang = 'H0003' WHERE MaThe = ma_the; 
                        ELSE  
                            UPDATE TheTichDiem SET Hang = 'H0004' WHERE MaThe = ma_the;  
                            END IF;
                        END IF;---end if xep hang
                    END IF;---end if kiem tra the 
                    FLAG_COMMIT := 0;
                ELSIF(tinh_trang_giao_hang = '1') THEN
                    UPDATE DonHang SET TinhTrangGiaoHang = '1', NhanVienPhuTrach = ma_nhan_vien WHERE MaDonHang = ma_don_hang;
                    UPDATE PhieuXuat SET TrangThai = 1 WHERE MaDonHang = ma_don_hang;
                    UPDATE PHIEUBAOHANH SET TRANGTHAI = 1 WHERE MADONHANG = MA_DON_HANG;
                    FLAG_COMMIT := 0;
                ELSE
                    RETURN_VALUE := 4;
                END IF;
            END IF;---END CHECK TAT CA
            IF(FLAG_COMMIT = 0) THEN
                COMMIT;
                RETURN_VALUE := 0;
            ELSE
                ROLLBACK;
            END IF;
    ELSE
        RETURN_VALUE := 1;
    END IF;
    EXCEPTION
        WHEN OTHERS THEN 
        ROLLBACK;
        RETURN_VALUE := -1;        
END;     