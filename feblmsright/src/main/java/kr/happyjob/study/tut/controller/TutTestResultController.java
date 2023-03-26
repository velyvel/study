package kr.happyjob.study.tut.controller;

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

import kr.happyjob.study.tut.model.TutTestResultModel;
import kr.happyjob.study.tut.service.TutTestResultService;


@Controller
@RequestMapping("/tut/")
public class TutTestResultController {
	
	@Autowired
	TutTestResultService tutTestResultService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	/**
	 * 초기화면
	 */
	@RequestMapping("testResult.do")
	public String testResult(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".testResult");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className + ".testResult");

		return "tut/testResult/testResult";
	}
	
	/**
	 * 초기화면
	 */
	@RequestMapping("testResultVue.do")
	public String testResultVue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".testResultVue");
		logger.info("   - paramMap : " + paramMap);
		
		logger.info("+ End " + className + ".testResultVue");

		return "tut/testResult/testResultVue";
	}
	
	/**
	 * 강의 목록 조회
	 */
	@RequestMapping("testResultLectureList.do")
	public String testResultLectureList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".testResultLectureList");
		logger.info("   - paramMap : " + paramMap);
		
		int pagenum =Integer.parseInt(String.valueOf(paramMap.get("pagenum")));
		int pageSize =Integer.parseInt(String.valueOf(paramMap.get("pageSize")));
		int startnum = (pagenum - 1) * pageSize;

		paramMap.put("startnum", startnum);
		paramMap.put("pageSize", pageSize);
		
		paramMap.put("loginId",session.getAttribute("loginId"));
		
		List<TutTestResultModel> testResultLectureList = tutTestResultService.testResultLectureList(paramMap);
		int totalcnt = tutTestResultService.testResultLectureListCnt(paramMap);
		
		model.addAttribute("testResultLectureList", testResultLectureList);
		model.addAttribute("totalcnt", totalcnt);
		
		logger.info("+ End " + className + ".testResultLectureList");

		return "tut/testResult/testResultLectureList";
	}

	/**
	 * 학생 강의 목록 조회
	 */
	@RequestMapping("testStudentSelectList.do")
	public String testStudentselectlist(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".testStudentSelectList");
		logger.info("   - paramMap : " + paramMap);
		
		int pagenum =Integer.parseInt(String.valueOf(paramMap.get("pagenum")));
		int pageSize =Integer.parseInt(String.valueOf(paramMap.get("pageSize")));
		int startnum = (pagenum - 1) * pageSize;

		paramMap.put("startnum", startnum);
		paramMap.put("pageSize", pageSize);
		
		paramMap.put("loginId",session.getAttribute("loginId"));
		
		List<TutTestResultModel> testStudentSelectList = tutTestResultService.testStudentSelectList(paramMap);
		int totalcnt = tutTestResultService.testStudentSelectListCnt(paramMap);
		
		model.addAttribute("testStudentSelectList", testStudentSelectList);
		model.addAttribute("totalcnt", totalcnt);
		
		logger.info("+ End " + className + ".testStudentSelectList");

		return "tut/testResult/testResultStudentList";
	}
	
	
}
