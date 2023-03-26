<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>LmsRight</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	// 강의 목록 페이징 설정
	var pageSizeLecture = 5;
	var pageBlockSizeLecture = 5;
	
	// 주차별 계획 목록 페이징 설정
	var pageSizeWeek = 5;
	var pageBlockSizeWeek = 10;
	
	
	/** OnLoad event */ 
	$(function() {
		comcombo("lecture_seq", "lectureseq", "all", "");
		
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
	});
	

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
			
				case 'btnLectureSearch' :
					lectureListPlanSearch();
					break;
				case 'btnSaveWeekPlan' :
					fn_insertweekplan();
					break;
				case 'btnDeleteWeekPlan' :
					$("#action").val("D");
					fn_insertweekplan();
				case 'btnCloseGrpCod' :
				case 'btnCloseDtlCod' :
					gfCloseModal();
					break;
			}
		});
	}
	
	
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="weekaction" id="weekaction" value="">
	<input type="hidden" name="weeklectureno" id="weeklectureno" value="">
	<input type="hidden" name="weekpagenum" id="weekpagenum" value="">
	<input type="hidden" name="loginID" id="loginID" value="">
	<input type="hidden" name="maxWeek" id="maxWeek" value="">
	<input type="hidden" name="maxemptiy" id="maxemptiy" value="">
	<input type="hidden" name="lectureStart" id="lectureStart" value="">
	<input type="hidden" name="lectureEnd" id="lectureEnd" value="">
	
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> <jsp:include
						page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">

						<p class="Location">
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">학습지원</span> <span class="btn_nav bold">강의계획서</span> 
								<a href="../tut/lecturePlan.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>강의계획서</span> <span class="fr"> 
							
								강의명
		     	                <input type="text" style="width: 300px; height: 25px;" id="lectureNameSearch" name="lectureNameSearch">                    
			                    <a href="" class="btnType blue" id="btnLectureSearch" name="btn"><span>검  색</span></a>
							</span>
						</p>
						
						<div class="divLectureList">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="25%">
									<col width="20%">
									<col width="20%">
									<col width="8%">
									<col width="8%">
									<col width="8%">
									<col width="11%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">강의명</th>
										<th scope="col">강의 시작날짜</th>
										<th scope="col">강의 종료날짜</th>
										<th scope="col">모집인원</th>
										<th scope="col">마감인원</th>
										<th scope="col">시험번호</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
								<tbody id="listLecturePlan"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="lecturePagination"> </div>
						
						<br/>
						<br/>
						
						<p class="conTitle" id="subtitle">
							<span>주차별 계획</span> <span class="fr"> 
							   
							    <a class="btnType blue" href="javascript:fn_WeekPlan();" name="modal"><span>신규등록</span></a>
							    <a class="btnType blue" href="" id="btnDeleteWeekPlan" name="btn"><span>마지막주차 삭제</span></a>
							</span>
						</p>
						
						<div class="WeekPlanList">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="15%">
									<col width="35%">
									<col width="35%">
									<col width="15%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">주차</th>
										<th scope="col">학습목표</th>
										<th scope="col">학습내용</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
								<tbody id="listWeekPlan"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="planPagination"> </div>
						
						
						
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<div id="layer1" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>강의 계획서</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">강사명</th>
							<td><input type="text" class="inputTxt p100" name="teacherName" id="teacherName" readonly/></td>
							<th scope="row">강의명 </th>
							<td><input type="text" class="inputTxt p100" name="lecture_name" id="lecture_name" readonly/></td>
						</tr>
						<tr>
							<th scope="row">강의 시작날짜 </th>
							<td><input type="date" class="inputTxt p100" name="lecture_start" id="lecture_start" readonly/></td>
							<th scope="row">강의 종료날짜 </th>
							<td><input type="date" class="inputTxt p100" name="lecture_end" id="lecture_end" readonly/></td>
						</tr>
						<tr>
							<th scope="row">모집인원 </th>
							<td><input type="text" class="inputTxt p100" name="lecture_person" id="lecture_person" readonly/></td>
							<th scope="row">마감인원 </th>
							<td><input type="text" class="inputTxt p100" name="lecture_total" id="lecture_total" readonly/></td>
						</tr>
						<tr>
							<th scope="row">시험번호 </th>
							<td><input type="text" class="inputTxt p100" name="test_no" id="test_no" readonly/></td>
						</tr>
						<tr>
							<th scope="row">수업목표 </th>
							<td colspan="4"><input type="text" class="inputTxt p200" name="lecture_goal" id="lecture_goal" readonly/></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href=""	class="btnType gray"  id="btnCloseGrpCod" name="btn"><span>닫기</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

	<div id="layer2" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>주차별계획 관리</strong>
			</dt>
			<dd class="content">

				<!-- s : 여기에 내용입력 -->

				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">주차 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" id="plan_week" name="plan_week" readonly/>
								<input type="hidden" class="inputTxt p100" id="plan_no" name="plan_no" />
							</td>
							<th scope="row">강의번호 </th>
							<td><input type="text" class="inputTxt p100" id="lecture_no" name="lecture_no" readonly/></td>
						</tr>
						<tr>
							<th scope="row">학습목표 <span class="font_red">*</span></th>
							<td colspan="4"><input type="text" class="inputTxt p100"
								id="plan_goal" name="plan_goal" /></td>
						</tr>
						<tr>
							<th scope="row">학습내용 <span class="font_red">*</span></th>
							<td colspan="4"><textarea type="text" class="inputTxt p100"
								id="plan_content" name="plan_content"></textarea></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveWeekPlan" name="btn"><span>저장</span></a>
					<a href="" class="btnType gray" id="btnCloseDtlCod" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	<!--// 모달팝업 -->
</form>
</body>
</html>