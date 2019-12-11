CREATE DATABASE ChiNhanh_1
USE ChiNhanh_1
GO

CREATE TABLE KhachHang(
 MaKhachHang nvarchar(20) not null primary key,
 HoKhachHang nvarchar(20) not null,
 TenKhachHang nvarchar(20) not null,
 NgaySinh  char(2),
 ThangSinh char(2) ,
 NamSinh char(4),
 ThoiGian  datetime,
 TrangThai bit
)
CREATE TABLE HoaDon (
 MaHD nvarchar(15) not null primary key,
 MaKH nvarchar(20) NOT NULL,
 SanPham nvarchar(30) not null,
 NgayLap date,
 DonGia float,
 SoLuong int,
 ThoiGian datetime,
 TrangThai bit
)

----- Tạo khoá ngoại-----
ALTER TABLE HoaDon
 ADD CONSTRAINT fk_hd_id_kh
  FOREIGN KEY (MaKH)
  REFERENCES KhachHang (MaKhachHang);
GO
---THÊM THÔNG TIN---
INSERT INTO KhachHang(MaKhachHang,HoKhachHang,TenKhachHang,NgaySinh,ThangSinh,NamSinh,ThoiGian,TrangThai)
VALUES('KH1',N'Nguyễn',N'Văn Thông','08','09','1999','2019-12-9',1),
('KH2',N'Nguyễn',N'Quốc Cảnh','12','01','1999','2019-12-8',0),
('KH3',N'Nguyễn',N'Ngọc Đức Hải','03','10','1999','2019-12-7',1)
INSERT INTO HoaDon(MaHD,MaKH,SanPham,NgayLap,SoLuong,DonGia,ThoiGian,TrangThai)
VALUES('HD1','KH1','iphone 11 Plus','2019-12-9',1,299990,'2019-12-10',1),
('HD2','KH3','SamSung Galaxy S10','2019-12-10',2,189990,'2019-12-10',0),
('HD3','KH2','OPPO F9','2019-12-8',2,399990,'2019-12-19',1)
GO

SELECT*FROM KhachHang
SELECT*FROM HoaDon

