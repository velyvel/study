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
	var pageSizeReference = 5;
	var pageBlockSizeReference = 5;
	
	// 상세코드 페이징 설정
	var pageSizeReferenceList = 5;
	var pageBlockSizeReferenceList = 10;
	
	
	/** OnLoad event */ 
	$(function() {
		comcombo("lecture_no", "lecturename", "all", "");
		
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
	});
	

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
				case 'btnSearchreference' :
					LectureList();
					break;
				case 'btnSaveReference' :
					fn_savereference();
					break;
				case 'btnDeleteReference' :
					$("#action").val("D");
					fn_savereference();
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
	<input type="hidden" name="referencepagenum" id="referencepagenum" value="">
	<input type="hidden" name="lectureseq" id="lectureseq" value="">
	<input type="hidden" name="slectureseq" id="slectureseq" value="">
	<input type="hidden" name="referenceno" id="referenceno" value="">
	
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
								class="btn_nav bold">학습지원</span> <span class="btn_nav bold">학습자료</span> 
								<a href="../tut/studyReference.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>학습자료</span> <span class="fr">
								<select name="lecturename" id="lecturename" style="width: 150px;"></select>
							    
								강의명                   
			                    <a href="" class="btnType blue" id="btnSearchreference" name="btn"><span>검  색</span></a>
							</span>
						</p>
						
						<div class="lectureReferenceList">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="45%">
									<col width="20%">
									<col width="20%">
									<col width="15%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">강의명</th>
										<th scope="col">강의시작날짜</th>
										<th scope="col">강의종료날짜</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
								<tbody id="Reference"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="referencePagination"> </div>
						
						<br/>
						<br/>
						
						
						<div class="ReferenceList">
						
						<p class="conTitle">
							<span>학습자료 목록</span> <span class="fr">

							    <a	class="btnType blue" href="javascript:fn_referencedownload();" name="modal"><span>자료등록</span></a>
							</span>
						</p>
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="40%">
									<col width="30%">
									<col width="20%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">제목</th>
										<th scope="col">등록일</th>
										<th scope="col">자료명</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
								<tbody id="ReferenceList"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="referenceListPagination"> </div>
						
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
				<strong>학습자료 등록 / 수정</strong>
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
							<input type="hidden" class="inputTxt p100" name="lecture_seq" id="lecture_seq" readonly/>
							<input type="hidden" class="inputTxt p100" name="reference_no" id="reference_no" readonly/>
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan=4><input type="text" class="inputTxt p100" name="reference_title" id="reference_title" /></td>
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan=4><textarea class="inputTxt p100" name="reference_content" id="reference_content"></textarea></td>
						</tr>
				
						<tr>
							<th scope="row">학습자료 </th>
							<td><input type="file" class="inputTxt p100" name="reference_file" id="reference_file" /></td>
							<td colspan=2><div id="fileinfo"></div></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveReference" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeleteReference" name="btn"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnCloseGrpCod" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	<!--// 모달팝업 -->
</form>
</body>
</html>