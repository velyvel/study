package kr.happyjob.study.tut.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.tut.model.LecturePlanListModel;
import kr.happyjob.study.tut.model.TutSurveyModel;
import kr.happyjob.study.tut.model.WeekPlanListModel;

public interface TutSurveyDao {


	// 설문조사 결과
	public List<TutSurveyModel> surveyResult(Map<String, Object> paramMap) throws Exception;
}
