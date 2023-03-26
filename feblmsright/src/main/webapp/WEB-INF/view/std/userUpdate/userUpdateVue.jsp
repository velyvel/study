<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>LmsRight</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<!-- 우편번호 찾기 -->
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	// 그룹코드 페이징 설정
	var pageSizeComnGrpCod = 5;
	var pageBlockSizeComnGrpCod = 5;

	// 상세코드 페이징 설정
	var pageSizeComnDtlCod = 5;
	var pageBlockSizeComnDtlCod = 10;

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
			case 'btnSave':
				studentUpdate();
				break;
			case 'btnCloseGrpCod':
			case 'btnCloseDtlCod':
				gfCloseModal();
				break;
			}
		});
	}

</script>

</head>
<body>
	<form id="myForm" action="" method="">
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
								<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
								<span class="btn_nav bold">학습관리</span> <span
									class="btn_nav bold">개인정보 수정</span> <a
									href="../std/userUpdate.do" class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>개인정보 수정</span>
							</p>

							<dd class="content">
								<!-- s : 여기에 내용입력 -->
								<table class="row">
									<caption>caption</caption>
									<colgroup>
										<col width="120px">
										<col width="300px">
										<col width="120px">
										<col width="300px">
									</colgroup>

									<tbody>
										<tr>
											<th scope="row">아이디 <span class="font_red">*</span></th>
											<td><input type="text" class="inputTxt p100"
												name="loginID" id="loginID" readonly /></td>
											<th scope="row">이름 <span class="font_red">*</span></th>
											<td><input type="text" class="inputTxt p100" name="name"
												id="name" /></td>
										</tr>
										<tr>
											<th scope="row">비밀번호 <span class="font_red">*</span></th>
											<td><input type="text" class="inputTxt p100"
												name="password" id="password" /></td>
											<th scope="row">비밀번호 확인 <span class="font_red">*</span></th>
											<td><input type="text" class="inputTxt p100"
												name="passwordResult" id="passwordResult" /></td>
										</tr>
										<tr>
											<th scope="row">우편번호 <span class="font_red">*</span></th>
											<td><input type="text" class="inputTxt p100"
												name="user_zipcode" id="user_zipcode" /> <input type="button"
												value="우편번호 찾기" onclick="execDaumPostcode()"
												style="width: 130px; height: 20px;" /></td>
											<th scope="row">주소 <span class="font_red">*</span></th>
											<td><input type="text" class="inputTxt p100" name="user_address"
												id="user_address" /></td>
										</tr>
										<tr>
											<th scope="row">연락처 <span class="font_red">*</span></th>
											<td><input type="text" class="inputTxt p100" name="user_hp"
												id="user_hp" /></td>
											<th scope="row">이메일 <span class="font_red">*</span></th>
											<td><input type="text" class="inputTxt p100"
												name="user_email" id="user_email" /></td>
										</tr>
									</tbody>
								</table>
								<br> <br> <br> <br> <br> <br>
								<p class="conTitle">
									<span>추가 입력사항</span>
								</p>

								<table class="row">
									<caption>caption</caption>
									<colgroup>
										<col width="120px">
										<col width="120px">
									</colgroup>

									<tbody>
										<tr>
											<th scope="row">파일첨부</th>
											<td><input type="file" class="inputTxt p100"
												name="selFile" id="selFile" />
											</td>
										</tr>
									</tbody>
								</table>


								<!-- e : 여기에 내용입력 -->

								<div class="btn_areaC mt30">
									<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a>
									<a href="" class="btnType gray" id="btnCloseGrpCod" name="btn"><span>취소</span></a>
								</div>
							</dd>
						</div> <!--// content -->

						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>
	</form>
</body>
</html>