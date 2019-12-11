﻿

CREATE DATABASE DATA_WAREHOUSE
use DATA_WAREHOUSE
go
-----Tạo bảng
CREATE TABLE HoaDon (
 MaHD nvarchar(15) not null ,
 MaKhachHang nvarchar(15) NOT NULL,
 SanPham nvarchar(30) not null,
 NgayLap date,
 DonGia float,
 SoLuong int,
 MaNguonDuLieu nvarchar(15) not null ,
 ThoiGian datetime,
 TrangThai bit,
 primary key(MaHD,MaNguonDuLieu)

)
CREATE TABLE KhachHang(
 MaKH NVARCHAR(15) not null,
 HoTen NVARCHAR(30),
 NgaySinh datetime,
 MaNguonDuLieu nvarchar(15) not null ,
 ThoiGian datetime,
 TrangThai bit,
 primary key(MaKH,MaNguonDuLieu)
)
CREATE TABLE ThoiGian(
 TenChiNhanh nvarchar(15),
 MaNguon nvarchar(15),
 ThoiGian datetime
 primary key (TenChiNhanh ,MaNguon)
)

--- TẠO KHOÁ NGOẠI ---
GO
ALTER TABLE [dbo].[HoaDon]
  ADD CONSTRAINT fk_HD_KH
  FOREIGN KEY (MaKhachHang,MaNguonDuLieu)
  REFERENCES [dbo].[KhachHang] (MaKH,MaNguonDuLieu);
  ---- chỉnh sửa cột---
  ALTER TABLE [dbo].[HoaDon]
DROP COLUMN ThoiGian;
  ALTER TABLE [dbo].[HoaDon]
DROP COLUMN TrangThai;
  ALTER TABLE [dbo].[KhachHang]
DROP COLUMN ThoiGian,TrangThai;
GO
----------NẠP DỮU LIỆU CHO KHÁCH HÀNG MÁY CHỦ -----------
--- function kiểm tra
IF OBJECT_ID('KIEMTRA_CN1') IS NOT NULL
DROP function KIEMTRA_CN1
GO
CREATE function KIEMTRA_CN1 (@MAKH NVARCHAR(15),@MA_NGUON NVARCHAR(15))
returns int
AS
BEGIN
     IF (EXISTS ( SELECT MaKH from DATA_WAREHOUSE.dbo.KhachHang where MaKH=@MAKH  AND MaNguonDuLieu=@MA_NGUON))
		 BEGIN
		  return 1-- 1 là tồn tại
		 END
	return 0 -- 0 là chưa tồn tại
END

---- THEM DU LIEU CN1 VAO DATA MAY CHU
IF exists(select * from sys.procedures where name = 'NapDuLieuChiNhanh1')
DROP proc NapDuLieuChiNhanh1
GO
create proc NapDuLieuChiNhanh1
as
begin
    DECLARE @MAKH NVARCHAR(10)
	declare a cursor for
	(
	-- chô này là lấy được toàn bộ dữ liệu chi nhánh 1
		select MaKhachHang,HoKhachHang,TenKhachHang,NgaySinh,ThangSinh,NamSinh from ChiNhanh_1.dbo.KhachHang 
	)
	open a

	DECLARE @HOKH NVARCHAR(10),@TENKH NVARCHAR(10),@NGS CHAR(2),@TS CHAR(2),@NS CHAR(2),@TG DATETIME,@TT CHAR(1)
	DECLARE @HOTEN NVARCHAR(45),@BIRTHDAY DATE, @MA_NGUON nvarchar(15)

	SET @MAKH = (SELECT MaKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE MaKhachHang=@MAKH)
	SELECT @HOKH=HoKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE HoKhachHang=@HOKH
	SELECT @TENKH=TenKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE TenKhachHang=@TENKH
	SET  @HOTEN=  CONCAT(@HOKH,' ',@TENKH)
	SET @BIRTHDAY=( SELECT CONCAT(NgaySinh,'-',ThangSinh,'-',NamSinh) AS BirthDay FROM ChiNhanh_1.dbo.KhachHang)
	SET @MA_NGUON =( SELECT MaNguonDuLieu FROM KhachHang WHERE MaNguonDuLieu=@MA_NGUON)

	-- chỗ này Đưa con trỏ vào dòng đầu tiên
	FETCH NEXT FROM a INTO @MAKH, @HOTEN, @BIRTHDAY, @MA_NGUON
	-- sau đó xuất ra thử
	while(@@FETCH_STATUS = 0)
	begin
		if(@TT = 0)
			begin
				--viet delete
			   
			 --   SELECT @MAKH=(SELECT MaKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE MaKhachHang=@MAKH)
				--SELECT @HOKH=(SELECT HoKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE HoKhachHang=@HOKH)
				--SET @TENKH=(SELECT TenKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE TenKhachHang=@TENKH)
				--SET  @HOTEN=  CONCAT(@HOKH,' ',@TENKH)
				--SET @BIRTHDAY=( SELECT CONCAT(NgaySinh,'-',ThangSinh,'-',NamSinh) AS BirthDay FROM ChiNhanh_1.dbo.KhachHang)
				--SET @MA_NGUON =( SELECT MaNguonDuLieu FROM KhachHang WHERE MaNguonDuLieu=@MA_NGUON)
                 
			     DELETE FROM  DATA_WAREHOUSE.dbo.KhachHang WHERE MaKH=@MAKH
			end
        ELSE if([dbo].[KIEMTRA_CN1](@MAKH,@MA_NGUON) = 1 )
		        
			BEGIN
		 		-- viet update
				--SELECT @MAKH=(SELECT MaKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE MaKhachHang=@MAKH)
				--SELECT @HOKH=(SELECT HoKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE HoKhachHang=@HOKH)
				--SET @TENKH=(SELECT TenKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE TenKhachHang=@TENKH)
				--SET  @HOTEN=  CONCAT(@HOKH,' ',@TENKH)
				--SET @BIRTHDAY=( SELECT CONCAT(NgaySinh,'-',ThangSinh,'-',NamSinh) AS BirthDay FROM ChiNhanh_1.dbo.KhachHang)
				--SET @MA_NGUON =( SELECT MaNguonDuLieu FROM KhachHang WHERE MaNguonDuLieu=@MA_NGUON)

			
				 UPDATE DATA_WAREHOUSE.dbo.KhachHang SET
				HoTen=@HOTEN , NgaySinh=@BIRTHDAY  WHERE MaKH=@MAKH AND MaNguonDuLieu=@MA_NGUON
			END
		else IF([dbo].[KIEMTRA_CN1](@MAKH,@MA_NGUON) = 0)
			BEGIN
				-- Sau đó insert dược chỗ này, thì mới xóa comment ở trên ra, va thôi
				-- dữa vào các biến đã lấy từ FETCH sau đó mới chuyển dổi dữ liệu
				-- là giờ thêm dữ liệu vào cn1  hết mới chuyển sang máy chủ pk
				-- viết hàm kiểm tra coi nó là insert , update hay delete rồi thêm vô máy chủ là xong

				--SELECT @MAKH=(SELECT MaKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE MaKhachHang=@MAKH)
				--SELECT @HOKH=(SELECT HoKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE HoKhachHang=@HOKH)
				--SET @TENKH=(SELECT TenKhachHang FROM ChiNhanh_1.dbo.KhachHang WHERE TenKhachHang=@TENKH)
				--SET  @HOTEN=  CONCAT(@HOKH,' ',@TENKH)
				--SET @BIRTHDAY=( SELECT CONCAT(NgaySinh,'-',ThangSinh,'-',NamSinh) AS BirthDay FROM ChiNhanh_1.dbo.KhachHang)
				--SET @MA_NGUON =( SELECT MaNguonDuLieu FROM KhachHang WHERE MaNguonDuLieu=@MA_NGUON)
				
				INSERT INTO KhachHang(MaKH,HoTen,NgaySinh,MaNguonDuLieu)
				Values(@MAKH,@HOTEN,@BIRTHDAY,@MA_NGUON)
		    END
	  	FETCH NEXT FROM a INTO @MAKH, @HOTEN, @BIRTHDAY, @MA_NGUON
	end
	CLOSE a
	DEALLOCATE a
end
GO	

EXEC NapDuLieuChiNhanh1 
select * from KhachHang


-------------- NẠP DỮ LIỆU CHO CN2 ------------------
---------- STORE CN2
GO
IF exists(select * from sys.procedures where name = 'NapDuLieuChiNhanh2')
DROP proc NapDuLieuChiNhanh2
GO
create proc NapDuLieuChiNhanh2
as
begin
    DECLARE @MAKH NVARCHAR(10)
	declare b cursor for
	(
		select * from ChiNhanh_2.[dbo].[KhachHang]
	)
	open b
	DECLARE @MAHD NVARCHAR(30),@TG DATETIME,@TT CHAR(1),@DG FLOAT,@SL INT
	DECLARE @HOTEN NVARCHAR(45),@BIRTHDAY DATE,@MA_NGUON NVARCHAR(15)
	SET @HOTEN=(SELECT HoTen FROM KhachHang WHERE HoTen=@HOTEN)
	SET @BIRTHDAY=( SELECT BirthDay FROM ChiNhanh_2.dbo.KhachHang WHERE BirthDay=@BIRTHDAY)
	SET @MAKH= (SELECT MaKH FROM KhachHang WHERE MaKH=@MAKH)
	SET @MA_NGUON=''
	FETCH NEXT FROM b INTO @MAKH, @HOTEN, @BIRTHDAY, @MA_NGUON -- chỗ này máy được từng dòng
	while(@@FETCH_STATUS = 0)
	begin
		if(@TT = 0)
			begin
				--viet delete
			   				
			   DELETE FROM  DATA_WAREHOUSE.[dbo].[KhachHang] WHERE  MaKH=@MAKH 
			
			end
        IF([dbo].[KIEMTRA_CN1](@MAKH,@MA_NGUON) = 1)
			BEGIN
		 		-- viet update
				 UPDATE DATA_WAREHOUSE.[dbo].[KhachHang] SET HoTen=@HOTEN,NgaySinh=@BIRTHDAY WHERE MaKH=@MAKH
			END
		IF([dbo].[KIEMTRA_CN1](@MAKH,@MA_NGUON) = 0)
			BEGIN
				--viet insert
				INSERT INTO DATA_WAREHOUSE.[dbo].[KhachHang](MaKH,HoTen,NgaySinh,MaNguonDuLieu)
		  Values(@MAKH,@HOTEN,@BIRTHDAY,@MA_NGUON)
				
			END
	  FETCH NEXT FROM b INTO @MAKH, @HOTEN, @BIRTHDAY, @MA_NGUON
	end
	CLOSE b
	DEALLOCATE b

end
EXEC NapDuLieuChiNhanh2
SELECT *FROM KhachHang

--------------- NẠP DỮ LIỆU CHO HOÁ ĐƠN--------------
--- function kiểm tra
IF OBJECT_ID('KIEMTRA_HD') IS NOT NULL
DROP function KIEMTRA_HD
GO
CREATE function KIEMTRA_HD (@MAHD NVARCHAR(15),@MA_NGUON NVARCHAR(15))
returns int
AS
BEGIN
     IF (EXISTS ( SELECT MaHD from DATA_WAREHOUSE.dbo.HoaDon where MaHD=@MAHD AND MaNguonDuLieu=@MA_NGUON ))
		 BEGIN
		  return 1-- 1 là tồn tại
		 END
	return 0 -- 0 là chưa tồn tại
END

---- VIẾT STORE
IF exists(select * from sys.procedures where name = 'NapDuLieuHoaDon')
DROP proc NapDuLieuHoaDon
GO
create proc NapDuLieuHoaDon
as
begin
    DECLARE @MAKH NVARCHAR(10)
	declare c cursor for
	(
		select MaHD,MaKH,SanPham,NgayLap,DonGia,SoLuong from ChiNhanh_1.dbo.HoaDon 
	)
	open c
	DECLARE @MAHD NVARCHAR(30),@TG DATETIME,@TT CHAR(1),@DG FLOAT,@SL INT
	DECLARE @SP NVARCHAR(30),@NGAY DATETIME,@MA_NGUON NVARCHAR(15)
	-- CHUYỂN DỮ LIỆU--
	--SELECT @MAHD=MaHD FROM ChiNhanh_1.[dbo].[HoaDon] 
	--SELECT @MAKH=MaKH FROM ChiNhanh_1.[dbo].[HoaDon]
	--SELECT @SP=SanPham FROM ChiNhanh_1.[dbo].[HoaDon]
	--SELECT @NGAY=NgayLap FROM ChiNhanh_1.[dbo].[HoaDon]
	--SELECT @DG=DonGia FROM ChiNhanh_1.[dbo].[HoaDon]
	--SELECT @SL=SoLuong FROM ChiNhanh_1.[dbo].[HoaDon]
	--SELECT @TT=TrangThai FROM ChiNhanh_1.[dbo].[HoaDon]
	SET @MAHD=(SELECT MaHD FROM ChiNhanh_1.[dbo].[HoaDon] WHERE MaHD=@MAHD )
	SET @MAKH=(SELECT MaKH FROM ChiNhanh_1.[dbo].[HoaDon] WHERE MaKH=@MAKH )
	SET @SP=(SELECT SanPham FROM ChiNhanh_1.[dbo].[HoaDon] WHERE SanPham=@SP )
	SET @DG=(SELECT DonGia FROM ChiNhanh_1.[dbo].[HoaDon] WHERE DonGia=@DG )
	SET @SL=(SELECT SoLuong FROM ChiNhanh_1.[dbo].[HoaDon] WHERE SoLuong=@SL )
	SET @TT=(SELECT TrangThai FROM ChiNhanh_1.[dbo].[HoaDon] WHERE TrangThai=@TT )
	SET @MA_NGUON=(SELECT MaNguonDuLieu  FROM DATA_WAREHOUSE.[dbo].[HoaDon] WHERE MaNguonDuLieu=@MA_NGUON )

	

	FETCH NEXT FROM c INTO @MAHD,@MAKH,@SP,@NGAY,@DG,@SL -- chỗ này máy được từng dòng
	while(@@FETCH_STATUS = 0)
	begin
		if(@TT=0)
			begin
				--viet delete
			   				
			   DELETE FROM  DATA_WAREHOUSE.dbo.HoaDon WHERE  MaHD=@MAHD 
			
			end
        IF([dbo].[KIEMTRA_HD](@MAHD,@MA_NGUON) = 1)
			BEGIN
		 		-- viet update
				 UPDATE  DATA_WAREHOUSE.dbo.HoaDon SET MaKhachHang=@MAKH,SanPham=@SP,NgayLap=@NGAY,DonGia=@DG,SoLuong=@SL
		    WHERE MaHD=@MAHD AND MaNguonDuLieu=@MA_NGUON AND MaKhachHang=@MAKH
			END
		IF([dbo].[KIEMTRA_HD](@MAHD,@MA_NGUON) = 0)
			BEGIN
				--viet insert
				INSERT INTO DATA_WAREHOUSE.dbo.HoaDon (MaHD,MaKhachHang,SanPham,NgayLap,DonGia,SoLuong,MaNguonDuLieu)
		  Values(@MAHD,@MAKH,@SP,@NGAY,@DG,@SL,@MA_NGUON)  
				
			END
	 FETCH NEXT FROM c INTO @MAHD,@MAKH,@SP,@NGAY,@DG,@SL
	end
	CLOSE c
	DEALLOCATE c
end
EXEC NapDuLieuHoaDon

SELECT *FROM HoaDon