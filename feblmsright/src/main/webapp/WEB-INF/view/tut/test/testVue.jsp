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

	// 시험 페이징 설정
	var pageSizeTest = 5;
	var pageBlockSizeTest = 5;
	
	/* // 문제 페이징 설정
	var pageSizeQuestion = 5;
	var pageBlockSizeQuestion = 10; */
	
	
	/** OnLoad event */ 
	$(function() {
		selectComCombo("test", "testSearch", "all", "");
		
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
		
	});
	

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
			case 'btnSearch':
				searchTest();
				break;			
			case 'btnSaveTest':
				fSaveTest();
				break;
			case 'btnDeleteTest':
				$("#action").val("D");
				fSaveTest();
				alert("삭제되었습니다.");
				console.log("삭제");
				break;
			case 'btnSaveQuestion':
				fSaveQuestion();
				alert("저장되었습니다.");
				break;
			case 'btnDeleteQuestion':
				$("#qaction").val("D");
				fSaveQuestion();
				alert("삭제되었습니다.");
				break;
			case 'btnSearchTest':
				searchTest();
				break;
			case 'btnCloseTest':
			case 'btnCloseQuestion':
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
	<input type="hidden" name="qaction" id="qaction" value="">
	<input type="hidden" name="btest_no" id="btest_no" value="">
	<input type="hidden" name="bkpagenum" id="bkpagenum" value="">
	<input type="hidden" name="loginID" id="loginID" value="${loginId}"><!-- 시험 시작날짜와 종료날짜 업데이트에 필요함-->
	<input type="hidden" name="lecture_seq" id="lecture_seq" value="" > <!-- 시험 시작날짜와 종료날짜 업데이트에 필요함-->
	
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
								class="btn_nav bold">학습관리</span> <span class="btn_nav bold">시험 관리</span> 
								<a href="../tut/test.do" class="btn_set refresh">새로고침</a>
						</p>
						
						
						<!-- div test는 시험명을 클릭했을때 사라지고,,, div question(문제목록)이 떠야한다  -->
						<div id="test">
						<p class="conTitle">
							<span>시험 관리</span> <span class="fr"> 
							   <select id="testSearch" name="testSearch" style="width: 150px;" onchange="javascript:searchTest();">
							    </select> 
							            
			                    <!-- <a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a> -->
							    <a class="btnType blue" href="javascript:fn_testRegPopup();" name="modal"><span>신규등록</span></a>
							</span>
						</p>
						
						<div class="tbodyTestList">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="*">
									<col width="*">
									<col width="*">
									<%-- <col width="20%">
									<col width="20%">
									<col width="10%">
									<col width="15%">
									<col width="10%"> --%>
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">시험이름</th>
										<th scope="col"></th>
										<!-- <th scope="col">시험시작일</th>
										<th scope="col">시험종료일</th> -->
									</tr>
								</thead>
								<tbody id="tbodyTestList"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="testListPagination"> </div>
						</div><!-- div test 의 끝 -->
						<br>
						<br>
						<!-- div question(문제목록) -->
						<div id="question">
						<p class="conTitle">
							<span>시험문제 관리</span> <span class="fr"> 
							  
							    <a	class="btnType blue" href="javascript:fn_questionPopup();" name="modal"><span>신규등록</span></a>
							    <a	class="btnType blue" href="javascript:history.go(0);" name="modal"><span>뒤로가기</span></a>
							</span>
						</p>
						
						<div class="tbodyQuestionList">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
									<col width="*">
								
									<%-- <col width="20%">
									<col width="20%">
									<col width="10%">
									<col width="15%">
									<col width="10%"> --%>
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">문제번호</th>
										<th scope="col">문제</th>
										<th scope="col">정답</th>
										<th scope="col">보기1</th>
										<th scope="col">보기2</th>
										<th scope="col">보기3</th>
										<th scope="col">보기4</th>
										<th scope="col">수정/삭제</th>
									
									</tr>
								</thead>
								<tbody id="tbodyQuestionList"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="questionListPagination"> </div>
						</div><!-- div question 의 끝 -->
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>


	<!-- 시험상세 모달팝업 -->
	<div id="layer1" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>시험일자 등록 및 수정</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="*">
						<col width="*">
						<col width="*">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">시험번호<span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="test_no" id="test_no" /></td>
							<th scope="row">시험명 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="test_title" id="test_title" /></td>
						</tr>
							<!-- <tr id ="CCC">
								<th scope="row">등록된 강의<span class="font_red">*</span></th>
								<a class="btnType3 color1" href="javascript:testDetailSelect();"  class="btnType blue" >강의검색</a>
								<td><select id="lecseqbyuserall" name="lecseqbyuserall"></select></td>
							</tr>
							
							<tr id ="DDD">
								<th scope="row">시험시작일<span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100" name="test_start" id="test_start" /></td>
								<th scope="row">시험종료일<span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100" name="test_end" id="test_end" /></td>
							</tr> -->
						<tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveTest" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeleteTest" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnCloseTest" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>


	<!-- 시험문제 모달-->
	<div id="layer2" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>시험문제 관리</strong>
			</dt>
			<dd class="content">

				<!-- s : 여기에 내용입력 -->

				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="80px">
						<col width="*">
						<col width="*">
						<col width="*">
						<col width="*">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<input type="hidden" name="qtest_no" id="qtest_no"  value=""/> <!-- 시험번호 숨기기 -->
							<th scope="row">문제번호  <!-- <span class="font_red">*</span> --></th>
							<td><input type="text" class="inputTxt p100" id="question_no" name="question_no" /></td>
							<th scope="row" style="width : 40px;">정답<!-- <span class="font_red">*</span> --></th>
							<td><input type="text" class="inputTxt p100" id="question_answer" name="question_answer" /></td>
							<th scope="row" style="width : 40px;">점수<!-- <span class="font_red">*</span> --></th>
							<td><input type="text"  class="inputTxt p100" id="question_score"  name="question_score" /></td>
						</tr>
						
						<tr>
							<th scope="row">문제</th>
							<td colspan="5"><input type="text" class="inputTxt p100"
								id="question_ex" name="question_ex" /></td>
						</tr>
						<tr>
							<th scope="row">문제1</th>
							<td colspan="5"><input type="text" class="inputTxt p100"
								id="question_one" name="question_one" /></td>
						</tr>
						<tr>
							<th scope="row">문제2</th>
							<td colspan="5"><input type="text" class="inputTxt p100"
								id="question_two" name="question_two" /></td>
						</tr>
						<tr>
							<th scope="row">문제3</th>
							<td colspan="5"><input type="text" class="inputTxt p100"
								id="question_three" name="question_three" /></td>
						</tr>
						<tr>
							<th scope="row">문제4</th>
							<td colspan="5"><input type="text" class="inputTxt p100"
								id="question_four" name="question_four" /></td>
						</tr>
						
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveQuestion" name="btn"><span>저장</span></a>
					<a href="" class="btnType blue" id="btnDeleteQuestion" name="btn"><span>삭제</span></a>  
					<a href="" class="btnType gray" id="btnCloseQuestion" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	<!--// 모달팝업 -->
</form>
</body>
</html>