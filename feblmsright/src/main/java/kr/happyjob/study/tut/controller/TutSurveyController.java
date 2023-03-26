package kr.happyjob.study.tut.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.adm.model.SurveyModel;
import kr.happyjob.study.tut.model.TutSurveyModel;
import kr.happyjob.study.tut.service.TutSurveyService;

@Controller
@RequestMapping("/tut/")
public class TutSurveyController {

	@Autowired
	TutSurveyService tutSurveyService;

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();

	/**
	 * 초기화면
	 */
	@RequestMapping("survey.do")
	public String survey(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".survey");
		logger.info("   - paramMap : " + paramMap);

		logger.info("+ End " + className + ".survey");

		return "tut/survey/survey";
	}
	
	/**
	 * 초기화면
	 */
	@RequestMapping("surveyVue.do")
	public String surveyVue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".surveyVue");
		logger.info("   - paramMap : " + paramMap);

		logger.info("+ End " + className + ".surveyVue");

		return "tut/survey/surveyVue";
	}

	// 설문조사 결과 조회
	@RequestMapping("surveyResult.do")
	@ResponseBody
	public Map<String, Object> surveyResult(Model model, @RequestParam Map<String, Object> paramMap,
			HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".surveyResult");
		logger.info("   - paramMap : " + paramMap);

		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		paramMap.put("loginID", session.getAttribute("loginId"));

		List<TutSurveyModel> surveyResult = tutSurveyService.surveyResult(paramMap);

		returnMap.put("surveyResult", surveyResult);

		logger.info("+ End " + className + ".surveyResult");

		return returnMap;
	}

}
