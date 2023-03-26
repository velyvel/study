<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>LmsRight : 강의 목록</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->
<style>
select[readonly] {
  background-color: #ddd;
  pointer-events: none;
}
</style>
<script type="text/javascript">

	// 그룹코드 페이징 설정
	var pageSizeLecture = 5;
	var pageBlockSizeLecture = 5;
	
	// 상세코드 페이징 설정
	var pageSizeStudent = 5;
	var pageBlockSizeStudent = 10;
	
	/** OnLoad event */ 
	$(function() {
		comcombo("lecture_no", "lectureName", "all", "");	
		
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
				case 'btnSearchLecture':
					lectureListSearch();
					break;
				case 'btnSaveLecture' :
					fn_SaveLecture();
					break;
				case 'btnUpdateLecture' :
					fn_SaveLecture();
					break;
/* 				case 'btnDeleteLecture' :
					$("#action").val("D");
					fn_SaveLecture();
					break; */
				case 'btnCloseLecture' :
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
	<input type="hidden" name="lectureNo" id="lectureNo" value="">
	<input type="hidden" name="lectureSeq" id="lectureSeq" value="">
	<input type="hidden" name="roomSeq" id="roomSeq" value="">
	<input type="hidden" name="bkpagenum" id="bkpagenum" value="">
	
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
								class="btn_nav bold">학습관리</span> <span class="btn_nav bold">강의관리</span> 
								<a href="../std/lectureList.do" class="btn_set refresh">새로고침</a>
						</p>
						
						<!-- 강의목록 select문 빼야될 수도 있어서 메모 -->
						<p class="conTitle">
							<span>강의관리</span> <span class="fr"> 
							    <select name="lectureName" id="lectureName" style="width: 150px;"></select>
							    
								마감인원	
		     	                <input type="text" style="width: 300px; height: 25px;" id="searchWord" name="searchWord" placeholder="숫자만 입력하세요." onkeydown="fFilterNumber(event);">                    
			                    <a href="" class="btnType blue" id="btnSearchLecture" name="btn"><span>검  색</span></a>
			                    <a class="btnType blue" href="javascript:fn_lecturePopup();" name="modal"><span>강의 등록</span></a>
			                    <span style="margin: 10px; "><input type="checkbox" id="depositCheck" onChange = "lectureListSearch()"> 종료여부 </span>
			                    
							</span>
						</p>
						
						<div class="divLectureList">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="15%">
									<col width="15%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">강사명</th>
										<th scope="col">강의명</th>
										<th scope="col">강의실</th>
										<th scope="col">강의 시작날짜</th>
										<th scope="col">강의 종료날짜</th>
										<th scope="col">모집인원</th>
										<th scope="col">마감인원</th>
										<th scope="col">종료여부</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
								<tbody id="listLecture"></tbody>
							</table>
	
						<div class="paging_area"  id="lecturePagination"> </div>
						</div>
						<br><br><br>
						
						<div id="divStudentList">
						
						<p class="conTitle">
							<span>학생정보</span> <span class="fr"> 
							</span>
						</p>
						
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
								</colgroup>
	     
								<thead>
									<tr>
										<th scope="col">강의번호</th>
										<th scope="col">학생명</th>
										<th scope="col">아이디</th>
										<th scope="col">과정명</th>
										<th scope="col">전화번호</th>
									</tr>
								</thead>
								<tbody id="listStudent"></tbody>
							</table>

						<div class="paging_area"  id="studentPagination"> </div>
						</div>
						
						
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
            <strong>강의 관리</strong>
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
                     <th scope="row">강사ID <span class="font_red">*</span></th>
                     <td colspan="3"><div id="loginIdDiv">  </div></td>                       
                  </tr>
                  <tr>
                     <th scope="row">시험과목 <span class="font_red">*</span></th>
                     <td colspan="3"><div id="testNoDiv">  </div></td>
                  </tr>
                  <tr>
                     <th scope="row">강의실 <span class="font_red">*</span></th>
                     <td colspan="3"><div id="lectureRoomDiv">  </div></td>
                  </tr>
                  <tr>
                     <th scope="row">마감인원 </th>
                     <td colspan="3"><input type="text" class="inputTxt p100"
                        name="lecture_total" id="lecture_total" placeholder="숫자만 입력하세요." onkeydown="fFilterNumber(event);"/></td>
                  </tr>
                  <tr>
                     <th scope="row">강의 시작날짜</th>
                     <td><input type="date" class="inputTxt p100"
                        name="lecture_start" id="lecture_start" style="font-size: 15px" /></td>
                     <th scope="row">강의 종료날짜</th>
                     <td><input type="date" class="inputTxt p100"
                        name="lecture_end" id="lecture_end" style="font-size: 15px" /></td>
                  </tr>
                  <tr>
                     <th scope="row">수업목표 </th>
                     <td colspan="3"><input type="text" class="inputTxt p100"
                        name="lecture_goal" id="lecture_goal" /></td>
                  </tr>
                  <tr>
                     <th scope="row">강의 종료여부 </th>
                     <td colspan="3"> <div id="lectureConfirmDiv">  </div>
                     	
                     </td>
                  </tr>
                  <tr>
                     <th scope="row">강의실 사용여부 </th>
                     <td colspan="3"> <div id="roomStatusDiv">  </div>
                     
                     </td>
                  </tr>
               </tbody>
            </table>

            <!-- e : 여기에 내용입력 -->

            <div class="btn_areaC mt30">
               <a href="" class="btnType blue" id="btnSaveLecture" name="btn"><span>저장</span></a>
              <!--  <a href="" class="btnType gray" id="btnDeleteLecture" name="btn"><span>삭제</span></a> --> 
               <a href=""   class="btnType gray"  id="btnCloseLecture" name="btn"><span>취소</span></a>
            </div>
         </dd>
      </dl>
      <a href="" class="closePop"><span class="hidden">닫기</span></a>
   </div>

 
   <!--// 모달팝업 -->

</form>
</body>
</html>