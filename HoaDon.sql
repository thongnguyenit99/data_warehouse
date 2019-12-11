IF OBJECT_ID('HoaDon') IS NOT NULL
DROP DATABASE HoaDon
GO
CREATE DATABASE HoaDon
USE HoaDon
GO

CREATE TABLE HoaDon (
 MaHD nvarchar(15) not null primary key,
 MaKH nvarchar(15) NOT NULL,
 SanPham nvarchar(30) not null,
 NgayLap date,
 DonGia float,
 SoLuong int,
 ThoiGian datetime,
 TrangThai char(1)
)
--THÊM DỮ LIỆU CHO HOÁ ĐƠN
INSERT INTO HoaDon(MaHD,MaKH,SanPham,NgayLap,SoLuong,DonGia,ThoiGian,TrangThai)
VALUES('HD1','KH1','iphone 11 Plus','2019-12-9',1,299990,'2019-12-10','1'),
('HD2','KH3','SamSung Galaxy S10','2019-12-10',2,189990,'2019-12-10','0'),
('HD3','KH2','OPPO F9','2019-12-8',2,399990,'2019-12-19','1')

SELECT*FROM HoaDon