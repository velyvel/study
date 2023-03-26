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
	// 수강 목록 페이징
	var pageSizeRegSubject = 5;
	var pageBlockSizeRegSubject = 5;

	/** OnLoad event */
	$(function() {

		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
	});

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
			$('a[name=btn]').click(function(e) {
				e.preventDefault();

				var btnId = $(this).attr('id');

				switch (btnId) {
				case 'btnInsert':
					fn_Insert();
					break;
				case 'btnSearch':
					regSubjetList();
					break;
				case 'btnCloseModal' :
					gfCloseModal();
					break;
				}
			});
		}
	
</script>

</head>
<body>
	<form id="myForm" action="" method="">
		<input type="hidden" name="bloginID" id="bloginID" value="">
		<input type="hidden" name="blecture_seq" id="blecture_seq" value="">


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
								<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
								<span class="btn_nav bold">학습관리</span> <span
									class="btn_nav bold">수강목록</span> <a href="../std/regSubject.do"
									class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>수강 목록</span><span class="fr"> 
								<select id="select" name="select" style="width: 100px;" >
									<option value = "">전체</option>
									<option value = "lecture">강의명</option>
									<option value = "name">강사</option>
							    </select> 
		     	                <input type="text" style="width: 150px; height: 25px;" id="search" name="search">                    
			                    <a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
			                    </span>
							</p>

							<div class="divComGrpCodList">

								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="6%">
										<col width="15%">
										<col width="15%">
										<col width="30%">
										<col width="10%">
									</colgroup>

									<thead>
										<tr>
											<th scope="col">순번</th>
											<th scope="col">강의명</th>
											<th scope="col">강사명</th>
											<th scope="col">강의 기간</th>
											<th scope="col">강의실</th>
										</tr>
									</thead>
									<tbody id="regSubjectList"></tbody>
								</table>
								<div class="paging_area" id="lectureListPagination"></div>
							</div>

							<br> <br> <br> <br> <br>

							<div id="lecturePlan">
								
							</div>

						</div> <!--// content -->
						
	

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>
		
		<!-- 모달팝업 -->


	<!--// 모달팝업 -->

	</form>
	<form id="surveyForm" action="" method="">	
	    <input type="hidden" name="bslecture_seq" id="bslecture_seq" value="1212">
	    <input type="hidden" name="servey_no" id="servey_no" value="">
		<div id="layer1" class="layerPop layerType2" style="width: 800px;">
			
		</div>
	</form>
</body>
</html>