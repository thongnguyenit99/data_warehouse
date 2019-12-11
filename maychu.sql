

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
--- TẠO KHOÁ NGOẠI ---
GO
ALTER TABLE [dbo].[HoaDon]
  ADD CONSTRAINT fk_HD_KH
  FOREIGN KEY (MaKhachHang,MaNguonDuLieu)
  REFERENCES [dbo].[KhachHang] (MaKH,MaNguonDuLieu);
GO

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
		select * from ChiNhanh_1.dbo.KhachHang
	)
	open a
	DECLARE @HOKH NVARCHAR(10),@TENKH NVARCHAR(10),@NGS CHAR(2),@TS CHAR(2),@NS CHAR(2),@TG DATETIME,@TT CHAR(1)
	DECLARE @HOTEN NVARCHAR(45),@BIRTHDAY DATE
	FETCH NEXT FROM a INTO @MAKH -- chỗ này máy được từng dòng
	while(@@FETCH_STATUS = 0)
	begin
		if(@TT = 0)
			begin
				--viet delete
			   SELECT  @HOTEN= ( SELECT CONCAT(HoKhachHang,' ',TenKhachHang) AS HoTen FROM ChiNhanh_1.dbo.KhachHang)
			   SELECT @BIRTHDAY=( SELECT CONCAT(NgaySinh,'-',ThangSinh,'-',NamSinh) AS BirthDay FROM ChiNhanh_1.dbo.KhachHang)
			   				
			   DELETE FROM  ChiNhanh_1.dbo.KhachHang WHERE  HoKhachHang=@HOKH AND TenKhachHang=@TENKH AND NgaySinh=@NGS
		   AND ThangSinh=@TS AND NamSinh=@NS AND ThoiGian=@TG AND TrangThai=@TT 
				
			end
        IF([dbo].[KIEMTRA_CN1](@MAKH) = 1)
			BEGIN
		 		-- viet update
				SELECT  @HOTEN= ( SELECT CONCAT(HoKhachHang,' ',TenKhachHang) AS HoTen FROM ChiNhanh_1.dbo.KhachHang)
			    SELECT @BIRTHDAY=( SELECT CONCAT(NgaySinh,'-',ThangSinh,'-',NamSinh) AS BirthDay FROM ChiNhanh_1.dbo.KhachHang)

				 UPDATE ChiNhanh_1.dbo.KhachHang SET
		HoKhachHang=@HOKH , TenKhachHang=@TENKH , NgaySinh=@NGS
		  , ThangSinh=@TS , NamSinh=@NS , ThoiGian=@TG , TrangThai=@TT
			END
		IF([dbo].[KIEMTRA_CN1](@MAKH) = 0)
			BEGIN
				--viet insert
				SELECT  @HOTEN= ( SELECT CONCAT(HoKhachHang,' ',TenKhachHang) AS HoTen FROM ChiNhanh_1.dbo.KhachHang)
			    SELECT @BIRTHDAY=( SELECT CONCAT(NgaySinh,'-',ThangSinh,'-',NamSinh) AS BirthDay FROM ChiNhanh_1.dbo.KhachHang)

				INSERT INTO ChiNhanh_1.dbo.KhachHang(MaKhachHang,HoKhachHang,TenKhachHang,NgaySinh,ThangSinh,NamSinh,ThoiGian,TrangThai)
		  Values(@MAKH,@HOKH,@TENKH,@NGS,@TS,@NS,@TG,@TT)
				
			END
	  FETCH NEXT FROM a INTO @MAKH
	end
	CLOSE a
	DEALLOCATE a

end

--- function kiểm tra
IF OBJECT_ID('KIEMTRA_CN1') IS NOT NULL
DROP function KIEMTRA_CN1
GO
CREATE function KIEMTRA_CN1 (@MAKH NVARCHAR(15))
returns int
AS
BEGIN
     IF (EXISTS ( SELECT MaKhachHang from ChiNhanh_1.dbo.KhachHang where MaKhachHang=@MAKH ))
		 BEGIN
		  return 1-- 1 là tồn tại
		 END
	return 0 -- 0 là chưa tồn tại
END

go
-------------- NẠP DỮ LIỆU CHO CN2 ------------------
IF exists(select * from sys.procedures where name = 'NapDuLieuChiNhanh2')
DROP proc NapDuLieuChiNhanh2
GO
create proc NapDuLieuChiNhanh2
as
begin
    DECLARE @MAKH NVARCHAR(10)
	declare b cursor for
	(
		select * from ChiNhanh_2.dbo.ChiNhanh_2
	)
	open b
	DECLARE @MAHD NVARCHAR(30),@TG DATETIME,@TT CHAR(1),@DG FLOAT,@SL INT
	DECLARE @HOTEN NVARCHAR(45),@BIRTHDAY DATE
	FETCH NEXT FROM b INTO @MAKH -- chỗ này máy được từng dòng
	while(@@FETCH_STATUS = 0)
	begin
		if(@TT = 0)
			begin
				--viet delete
			   				
			   DELETE FROM  ChiNhanh_2.dbo.ChiNhanh_2 WHERE  MaKhachHang=@MAKH 
			
			end
        IF([dbo].[KIEMTRA_CN2](@MAKH) = 1)
			BEGIN
		 		-- viet update
				 UPDATE ChiNhanh_2.dbo.ChiNhanh_2 SET MaHD=@MAHD,HoTen=@HOTEN,BirthDay=@BIRTHDAY,DonGia=@DG,SoLuong=@SL,
		 ThoiGian=@TG , TrangThai=@TT  WHERE MaKhachHang=@MAKH
			END
		IF([dbo].[KIEMTRA_CN2](@MAKH) = 0)
			BEGIN
				--viet insert
				INSERT INTO ChiNhanh_2.dbo.ChiNhanh_2(MaKhachHang,MaHD,HoTen,BirthDay,DonGia,SoLuong,ThoiGian,TrangThai)
		  Values(@MAKH,@MAHD,@HOTEN,@BIRTHDAY,@DG,@SL,@TG,@TT)
				
			END
	  FETCH NEXT FROM b INTO @MAKH
	end
	CLOSE b
	DEALLOCATE b

end

--- function kiểm tra
IF OBJECT_ID('KIEMTRA_CN2') IS NOT NULL
DROP function KIEMTRA_CN2
GO
CREATE function KIEMTRA_CN2 (@MAKH NVARCHAR(15))
returns int
AS
BEGIN
     IF (EXISTS ( SELECT MaKhachHang from ChiNhanh_2.[dbo].ChiNhanh_2 where MaKhachHang=@MAKH ))
		 BEGIN
		  return 1-- 1 là tồn tại
		 END
	return 0 -- 0 là chưa tồn tại
END
--------------- NẠP DỮ LIỆU CHO HOÁ ĐƠN--------------
IF exists(select * from sys.procedures where name = 'NapDuLieuHoaDon')
DROP proc NapDuLieuHoaDon
GO
create proc NapDuLieuHoaDon
as
begin
    DECLARE @MAKH NVARCHAR(10)
	declare c cursor for
	(
		select * from HoaDon.dbo.HoaDon
	)
	open c
	DECLARE @MAHD NVARCHAR(30),@TG DATETIME,@TT CHAR(1),@DG FLOAT,@SL INT
	DECLARE @SP NVARCHAR(30),@NGAY DATETIME
	FETCH NEXT FROM c INTO @MAHD -- chỗ này máy được từng dòng
	while(@@FETCH_STATUS = 0)
	begin
		if(@TT = 0)
			begin
				--viet delete
			   				
			   DELETE FROM  HoaDon.dbo.HoaDon WHERE  MaHD=@MAHD
			
			end
        IF([dbo].[KIEMTRA_HD](@MAHD) = 1)
			BEGIN
		 		-- viet update
				 UPDATE  HoaDon.dbo.HoaDon SET MaKH=@MAKH,SanPham=@SP,NgayLap=@NGAY,DonGia=@DG,SoLuong=@SL,
		 ThoiGian=@TG , TrangThai=@TT  WHERE MaHD=@MAHD
			END
		IF([dbo].[KIEMTRA_HD](@MAHD) = 0)
			BEGIN
				--viet insert
				INSERT INTO HoaDon.dbo.HoaDon (MaHD,MaKH,SanPham,NgayLap,DonGia,SoLuong,ThoiGian,TrangThai)
		  Values(@MAHD,@MAKH,@SP,@NGAY,@DG,@SL,@TG,@TT)
				
			END
	  FETCH NEXT FROM c INTO @MAHD
	end
	CLOSE c
	DEALLOCATE c
end

--- function kiểm tra
IF OBJECT_ID('KIEMTRA_HD') IS NOT NULL
DROP function KIEMTRA_HD
GO
CREATE function KIEMTRA_HD (@MAHD NVARCHAR(15))
returns int
AS
BEGIN
     IF (EXISTS ( SELECT MaHD from HoaDon.dbo.HoaDon where MaHD=@MAHD ))
		 BEGIN
		  return 1-- 1 là tồn tại
		 END
	return 0 -- 0 là chưa tồn tại
END

