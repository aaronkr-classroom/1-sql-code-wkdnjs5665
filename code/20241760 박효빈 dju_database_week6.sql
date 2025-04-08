
CREATE TABLE 과목2 (
    과목번호 CHAR(4) NOT NULL PRIMARY KEY,
	이름 VARCHAR(20) NOT NULL,
	강의실 CHAR(5) NOT NULL,
	개설학과 VARCHAR(20) NOT NULL,
	시수 INT NOT NULL
);

CREATE TABLE 학생2 (
    학번 CHAR(4) NOT NULL,
	이름 VARCHAR(20) NOT NULL,
	주소 VARCHAR(50) DEFAULT '미정',
	학년 INT NOT NULL,
	나이 INT NULL,
	성별 CHAR(1) NOT NULL,
	휴대폰번호 CHAR(13) NULL,
	소속학과 VARCHAR(20) NULL,
	PRIMARY KEY (학번),
	UNIQUE (휴대폰번호)
);

CREATE TABLE 수강2 (
    학번 CHAR(6) NOT NULL,
	과목번호 CHAR(4) NOT NULL,
	신청날짜 DATE NOT NULL,
	중간성적 INT NULL DEFAULT 0,
	기말성적 INT NULL DEFAULT 0,
	평가학점 CHAR(1) NULL, --A,B,C,D,E,F,P
	PRIMARY KEY (학번, 과목번호),
	FOREIGN KEY (학번) REFERENCES 학생2 (학번),
	FOREIGN KEY (과목번호) REFERENCES 과목2 (과목번호)
);

--존재하는 테이블, 데이터를 불러오고 사본 만듭니다.
INSERT INTO 과목2 SELECT * FROM 과목;
INSERT INTO 학생2 SELECT * FROM 학생;
INSERT INTO 수강2 SELECT * FROM 수강;

-- 괴목 테이블 입력
INSERT INTO 과목2
VALUES
('c001', '데이터베이스', '126', '컴퓨터', 3),
('c002', '정보보호', '137', '정보통신', 3),
('c003', '모바일웹', '128', '컴퓨터', 3),
('c004', '철학개론', '117', '철학', 2),
('c005', '전공글쓰기', '120', '교양학부', 1);

-- 학생 테이블입력
INSERT INTO 학생2
VALUES 
	('s001', '김연아', '서울 서초', 4, 23, '여', '010-1111-2222', '컴퓨터'),
	('s002', '홍길동', DEFAULT, 1, 26, '남', NULL, '통계'),
	('s003', '이승엽', NULL, 3, 30, '남', NULL, '정보통신'),
	('s004', '이영애', '경기 분당', 2, NULL, '여', '010-4444-5555', '정보통신'),
	('s005', '송윤아', '경기 분당', 4, 23, '여', '010-6666-7777', '컴퓨터'),
	('s006', '홍길동', '서울 종로', 2, 26, '남', '010-8888-9999', '컴퓨터'),
	('s007', '이온진', '경기 과천', 1, 23, '여', '010-2222-3333', '경영');

-- 학생 테이블생성
CREATE TABLE 학생2
( 학번 CHAR(4) NOT NULL,
이름 VARCHAR(20) NOT NULL,
주소 VARCHAR(50) NULL DEFAULT '미정',
학년 INT NOT NULL,
나이 INT NULL,
성별 CHAR(1) NOT NULL,
휴대폰번호 CHAR(14) NULL,
소속학과 VARCHAR(20) NULL,
PRIMARY KEY (학번));



 INSERT INTO 학생2 
 VALUES ('s003', '이순신', DEFAULT, 4, 54, '남' , NULL, NULL);

 TABLE 학생2;
 TABLE 과목2;
 TABLE 수강2;

 --ALTER TABLE문(테이블 수정/변경)
 ALTER TABLE 학생2
     ADD COLUMN 등록날짜 DATE NOT NULL DEFAULT '2025-04-08';

ALTER TABLE 수강2
    ADD COLUMN 등록날짜 DATE NOT NULL DEFAULT '2025-04-08';


ALTER TABLE 수강2 DROP COLUMN 등록날짜;

--학생2 테이블의 사본 만들기
CREATE TABLE 학생3 AS SELECT * FROM 학생2;
TABLE 학생3;
DROP TABLE 학생3;


--사용자와 권한에 대한 명령문
SELECT current_user;

CREATE USER manager WITH PASSWORD '0000';
GRANT ALL PRIVILEGES ON DATABASE univdb TO manager;--DB에서만 권한 부여
GRANT ALL PRIVILEGES ON 학생2, 수강2, 과목2 TO manager;

ALTER DATABASE univdb OWNER TO manager;--소유자도 변경하면 모든 권한이 있다.

INSERT INTO 과목2
VALUES ('c012', '데이터', 'dj408', '정보보안', 4);
--사용자 변경--
INSERT INTO 과목2
VALUES ('c022', '데이터 과학', 'dj408', '정보통신', 5);

--뷰 생성하기
CREATE VIEW V1_고학년학생(학생이름, 나이, 성, 학년) AS
  SELECT 이름, 나이, 성별, 학년 FROM 학생2
  WHERE 학년 >=3 AND 학년 <=4;

 SELECT * FROM V1_고학년학생;

DROP VIEW IF EXISTS V2_과목수강현황;

CREATE VIEW V2_과목수강현황(과목번호, 강의실, 수강인원수) AS 
    SELECT 과목2.과목번호, 강의실, COUNT(과목2.과목번호)
	FROM 과목2 JOIN 수강2 ON 과목2.과목번호 = 수강2.과목번호
	GROUP BY 과목2.과목번호;

SELECT * FROM V2_과목수강현황;

CREATE VIEW V3_고학년여학생 AS 
    SELECT * FROM V1_고학년학생
	WHERE 성 = '여';

SELECT * FROM V3_고학년여학생;	

--인덱스
GRANT ALL ON SCHEMA public TO manager;
ALTER TABLE 수강2 OWNER TO manager;

CREATE INDEX idx_수강 ON 수강2(학번, 과목번호);
CREATE UNIQUE INDEX idx_과목 ON 과목2(이름 ASC);
CREATE UNIQUE INDEX idx_학생 ON 학생2(학번);

