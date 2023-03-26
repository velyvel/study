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

<script type="text/javascript">

	// 그룹코드 페이징 설정
	var pageSizeLecture = 5;
	var pageBlockSizeLecture = 5;
	
	// 상세코드 페이징 설정
	var pageSizeComnDtlCod = 5;
	var pageBlockSizeComnDtlCod = 10;
	
	
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
					studentInsert();
					break;
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
	<input type="hidden" name="lectureSeq" id="lectureSeq" value="">
	<input type="hidden" name="action" id="action" value="">
	
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
								class="btn_nav bold">학습지원</span> <span class="btn_nav bold">강의목록</span> 
								<a href="../std/lectureList.do" class="btn_set refresh">새로고침</a>
						</p>
						
						<!-- 강의목록 select문 빼야될 수도 있어서 메모 -->
						<p class="conTitle">
							<span>강의목록</span> <span class="fr"> 
							    <select name="lectureName" id="lectureName" style="width: 150px;"></select>
							    
								마감인원	
		     	                <input type="text" style="width: 300px; height: 25px;" id="searchWord" name="searchWord">                    
			                    <a href="" class="btnType blue" id="btnSearchLecture" name="btn"><span>검  색</span></a>
							</span>
						</p>
						
						<div class="divLectureList">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="20%">
									<col width="10%">
									<col width="20%">
									<col width="20%">
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
									</tr>
								</thead>
								<tbody id="listLecture"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="lecturePagination"> </div>
						
						
						
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<div id="layer1" class="layerPop layerType2" style="width: 1000px;">
	<dl>
				<dt>
					<strong>강의 신청</strong>
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
								<th scope="row">과목 </th>
								<td><div id="lectureNameDiv">  </div></td>
								<th scope="row">강사명 </th>
								<td><div id="teacherNameDiv">  </div></td>
							</tr>
							<tr>
								<th scope="row">강의 시작일 </th>
								<td><div id="lectureStartDiv">  </div></td>
									<th scope="row">강의 마감일 </th>
								<td><div id="lectureEndDiv">  </div></td>
							</tr>
							<tr>
								<th scope="row">모집인원 </th>
								<td><div id="lecturePersonDiv">  </div></td>
									<th scope="row">마감인원 </th>
								<td><div id="lectureTotalDiv">  </div></td>
							</tr>
							<tr>
								<th scope="row">수업목표</th>
								<td><div id="lectureGoalDiv">  </div></td>
								<th scope="row">강의실</th>
								<td><div id="roomNameDiv">  </div></td>
							</tr>
							<tr>
								<th scope="row">강의계획</th>
								<td colspan="3"><div id="lecturePlanDiv">
								
								<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="30%">
									<col width="60%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">주 차수</th>
										<th scope="col">학습목표</th>
										<th scope="col">학습내용</th>
									</tr>
								</thead>
								<tbody id="listPlan"></tbody>
							</table>
						</div>
							</td>
							</tr>
						</tbody>
					</table>
	
					<!-- e : 여기에 내용입력 -->
	
					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSaveLecture" name="btn"><span>신청</span></a> 
						<a href=""	class="btnType gray"  id="btnCloseLecture" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
	</div>
	<!--// 모달팝업 -->
</form>
</body>
</html>