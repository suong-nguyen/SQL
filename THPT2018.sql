CREATE DATABASE THPT2018;
USE THPT2018;

-- Create Tables

CREATE TABLE Province (
    province_code VARCHAR(2) PRIMARY KEY,
    province_name VARCHAR(50)
);

CREATE TABLE Candidate (
    candidate_id VARCHAR(8) PRIMARY KEY,
    province_code VARCHAR(2),
    FOREIGN KEY (province_code) REFERENCES Province(province_code)
);

CREATE TABLE Subject_info (
    subject_id VARCHAR(10) PRIMARY KEY,
    subject_name VARCHAR(50)
);

CREATE TABLE Candidate_Subject (
    candidate_id VARCHAR(8),
    subject_id VARCHAR(10),
    score FLOAT,
    PRIMARY KEY (candidate_id, subject_id),
    FOREIGN KEY (candidate_id) REFERENCES Candidate(candidate_id),
    FOREIGN KEY (subject_id) REFERENCES Subject_info(subject_id)
);

CREATE TABLE Block_info (
    block_id VARCHAR(3) PRIMARY KEY,
    block_name VARCHAR(50)
);

CREATE TABLE Block_Subject (
    block_id VARCHAR(3),
    subject_id VARCHAR(10),
    PRIMARY KEY (block_id, subject_id),
    FOREIGN KEY (block_id) REFERENCES Block_info(block_id),
    FOREIGN KEY (subject_id) REFERENCES Subject_info(subject_id)
);

CREATE TABLE Candidate_Block (
    candidate_id VARCHAR(8),
    block_id VARCHAR(3), -- Adjusted the length to match Block_info
    score FLOAT,
    PRIMARY KEY (candidate_id, block_id),
    FOREIGN KEY (candidate_id) REFERENCES Candidate(candidate_id),
    FOREIGN KEY (block_id) REFERENCES Block_info(block_id)
);

--Insert Candidate Block
SELECT cs.candidate_id, bi.block_id, SUM(cs.score)
FROM Candidate_Subject cs
JOIN Block_Subject bs ON cs.subject_id = bs.subject_id
JOIN Block_info bi ON bs.block_id = bi.block_id
GROUP BY cs.candidate_id, bi.block_id;

-- Insert_Province_Block_Subject
INSERT INTO Province (province_code, province_name) values ('1','Hanoi');
INSERT INTO Province (province_code, province_name) values ('2','Ho Chi Minh City');
INSERT INTO Province (province_code, province_name) values ('3','Hai Phong');
INSERT INTO Province (province_code, province_name) values ('4','Da Nang');
INSERT INTO Province (province_code, province_name) values ('5','Ha Giang');
INSERT INTO Province (province_code, province_name) values ('6','Cao Bang');
INSERT INTO Province (province_code, province_name) values ('7','Lai Chau');
INSERT INTO Province (province_code, province_name) values ('8','Lao Cai');
INSERT INTO Province (province_code, province_name) values ('9','Tuyen Quang');
INSERT INTO Province (province_code, province_name) values ('10','Lang Son');
INSERT INTO Province (province_code, province_name) values ('11','Bac Kan');
INSERT INTO Province (province_code, province_name) values ('12','Thai Nguyen');
INSERT INTO Province (province_code, province_name) values ('13','Yen Bai');
INSERT INTO Province (province_code, province_name) values ('14','Son La');
INSERT INTO Province (province_code, province_name) values ('15','Phu Tho');
INSERT INTO Province (province_code, province_name) values ('16','Vinh Phuc');
INSERT INTO Province (province_code, province_name) values ('17','Quang Ninh');
INSERT INTO Province (province_code, province_name) values ('18','Bac Giang');
INSERT INTO Province (province_code, province_name) values ('19','Bac Ninh');
INSERT INTO Province (province_code, province_name) values ('21','Hai Duong');
INSERT INTO Province (province_code, province_name) values ('22','Hung Yen');
INSERT INTO Province (province_code, province_name) values ('23','Hoa Binh');
INSERT INTO Province (province_code, province_name) values ('24','Ha Nam');
INSERT INTO Province (province_code, province_name) values ('25','Nam Dinh');
INSERT INTO Province (province_code, province_name) values ('26','Thai Binh');
INSERT INTO Province (province_code, province_name) values ('27','Ninh Binh');
INSERT INTO Province (province_code, province_name) values ('28','Thanh Hoa');
INSERT INTO Province (province_code, province_name) values ('29','Nghe An');
INSERT INTO Province (province_code, province_name) values ('30','Ha Tinh');
INSERT INTO Province (province_code, province_name) values ('31','Quang Binh');
INSERT INTO Province (province_code, province_name) values ('32','Quang Tri');
INSERT INTO Province (province_code, province_name) values ('33','Thua Thien-Hue');
INSERT INTO Province (province_code, province_name) values ('34','Quang Nam');
INSERT INTO Province (province_code, province_name) values ('35','Quang Ngai');
INSERT INTO Province (province_code, province_name) values ('36','Kon Tum');
INSERT INTO Province (province_code, province_name) values ('37','Binh Dinh');
INSERT INTO Province (province_code, province_name) values ('38','Gia Lai');
INSERT INTO Province (province_code, province_name) values ('39','Phu Yen');
INSERT INTO Province (province_code, province_name) values ('40','Dak Lak');
INSERT INTO Province (province_code, province_name) values ('41','Khanh Hoa');
INSERT INTO Province (province_code, province_name) values ('42','Lam Dong');
INSERT INTO Province (province_code, province_name) values ('43','Binh Phuoc');
INSERT INTO Province (province_code, province_name) values ('44','Binh Duong');
INSERT INTO Province (province_code, province_name) values ('45','Ninh Thuan');
INSERT INTO Province (province_code, province_name) values ('46','Tay Ninh');
INSERT INTO Province (province_code, province_name) values ('47','Binh Thuan');
INSERT INTO Province (province_code, province_name) values ('48','Dong Nai');
INSERT INTO Province (province_code, province_name) values ('49','Long An');
INSERT INTO Province (province_code, province_name) values ('50','Dong Thap');
INSERT INTO Province (province_code, province_name) values ('51','An Giang');
INSERT INTO Province (province_code, province_name) values ('52','Ba Ria-Vung Tau');
INSERT INTO Province (province_code, province_name) values ('53','Tien Giang');
INSERT INTO Province (province_code, province_name) values ('54','Kien Giang');
INSERT INTO Province (province_code, province_name) values ('55','Can Tho');
INSERT INTO Province (province_code, province_name) values ('56','Ben Tre');
INSERT INTO Province (province_code, province_name) values ('57','Vinh Long');
INSERT INTO Province (province_code, province_name) values ('58','Tra Vinh');
INSERT INTO Province (province_code, province_name) values ('59','Soc Trang');
INSERT INTO Province (province_code, province_name) values ('60','Bac Lieu');
INSERT INTO Province (province_code, province_name) values ('61','Ca Mau');
INSERT INTO Province (province_code, province_name) values ('62','Dien Bien');
INSERT INTO Province (province_code, province_name) values ('63','Dak Nong');
INSERT INTO Province (province_code, province_name) values ('64','Hau Giang');

INSERT INTO Block_info (block_id, block_name) values ('A00','Group A00 (Mathematics, Physics, Chemistry)');
INSERT INTO Block_info (block_id, block_name) values ('A01','Group A01 (Mathematics, Physics, English)');
INSERT INTO Block_info (block_id, block_name) values ('B00','Group B00 (Mathematics, Chemistry, Biology)');
INSERT INTO Block_info (block_id, block_name) values ('C00','Group C00 (Literature, History, Geography)');
INSERT INTO Block_info (block_id, block_name) values ('D01','Group D01 (Mathematics, Literature, English)');

INSERT INTO Subject_info (subject_id, subject_name) values ('Mathematics','Mathematics');
INSERT INTO Subject_info (subject_id, subject_name) values ('Physics','Physics');
INSERT INTO Subject_info (subject_id, subject_name) values ('Chemistry','Chemistry');
INSERT INTO Subject_info (subject_id, subject_name) values ('English','English');
INSERT INTO Subject_info (subject_id, subject_name) values ('Biology','Biology');
INSERT INTO Subject_info (subject_id, subject_name) values ('Literature','Literature');
INSERT INTO Subject_info (subject_id, subject_name) values ('History','History');
INSERT INTO Subject_info (subject_id, subject_name) values ('Geography','Geography');
INSERT INTO Subject_info (subject_id, subject_name) values ('Citizenship Education','Citizenship Education');

INSERT INTO Block_Subject (block_id, subject_id) values ('A00','Mathematics');
INSERT INTO Block_Subject (block_id, subject_id) values ('A00','Physics');
INSERT INTO Block_Subject (block_id, subject_id) values ('A00','Chemistry');
INSERT INTO Block_Subject (block_id, subject_id) values ('A01','Mathematics');
INSERT INTO Block_Subject (block_id, subject_id) values ('A01','Physics');
INSERT INTO Block_Subject (block_id, subject_id) values ('A01','English');
INSERT INTO Block_Subject (block_id, subject_id) values ('B00','Mathematics');
INSERT INTO Block_Subject (block_id, subject_id) values ('B00','Chemistry');
INSERT INTO Block_Subject (block_id, subject_id) values ('B00','Biology');
INSERT INTO Block_Subject (block_id, subject_id) values ('C00','Literature');
INSERT INTO Block_Subject (block_id, subject_id) values ('C00','History');
INSERT INTO Block_Subject (block_id, subject_id) values ('C00','Geography');
INSERT INTO Block_Subject (block_id, subject_id) values ('D01','Mathematics');
INSERT INTO Block_Subject (block_id, subject_id) values ('D01','Literature');
INSERT INTO Block_Subject (block_id, subject_id) values ('D01','English');

-- Check data
Select * from Block_Subject