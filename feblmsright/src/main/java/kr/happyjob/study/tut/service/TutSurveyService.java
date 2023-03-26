package kr.happyjob.study.tut.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.happyjob.study.tut.model.LectureModel;
import kr.happyjob.study.tut.model.PlanListModel;
import kr.happyjob.study.tut.model.TaskModel;
import kr.happyjob.study.tut.model.TaskSendModel;
import kr.happyjob.study.tut.model.TutSurveyModel;

public interface TutSurveyService {
	
	// 설문조사 결과
	public List<TutSurveyModel> surveyResult(Map<String, Object> paramMap) throws Exception;

} 
