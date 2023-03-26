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

	// 그룹코드 페이징 설정
	var emppageSize = 5;
	var emppageBlockSize = 10;
	
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
				//학생 신규등록 버튼
				case 'empnewpopup':
					$("#action").val("I");
					empnewpopup(stdID, stdname);
					break;
				//수정 >  수정완료 버튼
				case 'btnSaveempstudent':
					$("#action").val("I");
					fn_insertempstudent();
					break;
				//수정완료 버튼
				case 'btnUpdateempstudent' :
					$("#action").val("U");
					fn_btnempupdate();
					break;
				//검색 버튼
				case 'btnempstuSearch':
					employclasssearchlist();
					break;
				//닫기 버튼
				case 'btnCloseGrpCod' :
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
	<input type="hidden" name="stdname" id="stdname" value="">
	<input type="hidden" name="stdID" id="stdID" value="">
	<input type="hidden" name="emp_no" id="emp_no" value="">
	
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 -->
					<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">

						<p class="Location">
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">취업관리</span> <span class="btn_nav bold">취업 정보</span> 
								<a href="../adm/employ.do" class="btn_set refresh">새로고침</a>
						</p>
						
					<p class="conTitle">
							<span>취업 정보 등록</span> <span class="fr"> 
		     	                <input type="text" style="width: 300px; height: 25px;" id="empstuSearch" name="empstuSearch" placeholder="학생 아이디로 검색">                    
			                    <a href="" class="btnType blue" id="btnempstuSearch" name="btn"><span>검  색</span></a>
							</span>
					</p>
					<div class="employclassList">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="20%">
									<col width="20%">
									<col width="15%">
									<col width="25%">
									<col width="20%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">학생명</th>
										<th scope="col">연락처</th>
										<th scope="col">아이디</th>
										<th scope="col">가입일자</th>
										<th scope="col">확인</th>
									</tr>
								</thead>
								<tbody id="detailstuclasslist"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="detailstudentclassPagination"> </div>
						
						<br><br><br><br>
						
						<div id="studentdetailcontent">
						<p>
						<div id="detail_btn">
							<span class="fr">
		     	                <a href="javascript:empnewpopup()" class="btnType blue" id="emp_updqte_data" name="modal"><span>신규등록</span></a>
							</span>
						</div>
						</p>
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="5%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="5%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">학번</th>
										<th scope="col">아이디(정보수정)</th>
										<th scope="col">학생명</th>
										<th scope="col">업체명</th>
										<th scope="col">재직여부(N/Y)</th>
										<th scope="col">입사일</th>
										<th scope="col">퇴사일</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
								<tbody id="detailempcontent"></tbody>
							</table>
						</div>
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
				<strong>학생정보수정</strong>
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
							<th scope="col">학번</th>
							<td colspan="7"><div id="upemp_no"></div></td>
						</tr>
						<tr>
							<th scope="col">학생명</th>
							<td colspan="3"><div id="upstdempname"></div></td>
							<th scope="col">아이디</th>
							<td colspan="3"><div id="upstdloginID"></div></td>
						</tr>
						<tr>
							<th scope="col">업체명</th>
							<td colspan="3"><input type="text" class="inputTxt p100" id="emp_update_name" name="emp_update_name" /></td>
							<th scope="col">재직여부</th>
							<td colspan="3">
							<input type="radio" id="radio1-1" name="emp_update_state" id="emp_update_state_1" value="Y" /> <label for="radio1-1">Y</label>
								&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="radio1-2" name="emp_update_state" id="emp_update_state_2" value="N" /> <label for="radio1-2">N</label>
							</td>
						</tr>
						<tr>
							<th scope="col">입사일</th>
							<td colspan="3"><input type="text" class="inputTxt p100" id="emp_update_join" name="emp_update_join" /></td>
							<th scope="col">퇴사일</th>
							<td colspan="3"><input type="text" class="inputTxt p100" id="emp_update_leave" name="emp_update_leave" /></td>
						</tr>
					</tbody>
					
				</table>
				<div class="btn_areaC mt30">
					<a href="" class="btnType gray" id="btnUpdateempstudent" name="btn"><span>수정 완료</span></a>
					<a href=""	class="btnType gray"  id="btnCloseGrpCod" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	<div id="layer2" class="layerPop layerType2" style="width: 1000px;">
		<dl>
			<dt>
				<strong>학생정보</strong>
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
							<th scope="col">학번</th>
							<td colspan="7"><div id="emp_no"></div></td>
						</tr>
						<tr>
							<th scope="col">학생명</th>
							<td colspan="3"><div id="stdempname"></div></td>
							<th scope="col">아이디</th>
							<td colspan="3"><div id="stdloginID"></div></td>
						</tr>
						<tr>
							<th scope="col">업체명</th>
							<td colspan="3"><input type="text" class="inputTxt p100" id="emp_name" name="emp_name" /></td>
							<th scope="col">재직여부</th>
							<td colspan="3">
							<input type="radio" id="radio1-1" name="emp_state" id="emp_state_1" value="Y" /> <label for="radio1-1">Y</label>
								&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="radio1-2" name="emp_state" id="emp_state_2" value="N" /> <label for="radio1-2">N</label>
							</td>
						</tr>
						<tr>
							<th scope="col">입사일</th>
							<td colspan="3"><input type="text" class="inputTxt p100" id="emp_join" name="emp_join" /></td>
							<th scope="col">퇴사일</th>
							<td colspan="3"><input type="text" class="inputTxt p100" id="emp_leave" name="emp_leave" /></td>
						</tr>
					</tbody>
					
				</table>
				<div class="btn_areaC mt30">
					<a href="" class="btnType gray" id="btnSaveempstudent" name="btn"><span>등록완료</span></a>
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