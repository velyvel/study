package kr.happyjob.study.adm.dao;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.adm.model.EmployModel;


public interface EmployDao {
	// 로그인 사용자 정보 불러오기
	//public QnaModel userinfo(Map<String, Object> paramMap);
	
	//취업을 위한 학생 리스트 가져오기. empclasslist
	public List<EmployModel> empclasslist(Map<String, Object> paramMap);
	
	//취업을 위한 학생 리스트 cnt studentclasscnt
	public int studentclasscnt(Map<String, Object> paramMap);
	
	//학생 employee detail 내용 detailcontent
	public List<EmployModel> detailcontent(Map<String, Object> paramMap);
	
	//학생 employee detail 리스트 cnt detailcnt
	public int detailcnt(Map<String, Object> paramMap);
	
	//상단에 취업 학생 list 추가하기.
	public int empinsert(Map<String, Object> paramMap);
	
	//하단에서 수정 하기.empupdate
	public int empupdate(Map<String, Object> paramMap);
}