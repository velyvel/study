package kr.happyjob.study.tut.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.tut.dao.TutSurveyDao;
import kr.happyjob.study.tut.model.TutSurveyModel;


@Service
public class TutSurveyServiceImpl implements TutSurveyService {
	
	@Autowired
	TutSurveyDao tutSurveyDao;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
   
	// Get class name for logger
  	private final String className = this.getClass().toString();
  	
  	//설문 조사 결과
	@Override
	public List<TutSurveyModel> surveyResult(Map<String, Object> paramMap) throws Exception {
		// TODO Auto-generated method stub
		return tutSurveyDao.surveyResult(paramMap);
	}
	
	

}
