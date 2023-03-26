<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${sessionScope.userType ne 'C'}">
	<c:redirect url="/dashboard/dashboard.do" />
</c:if>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>study</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	// 강의실 페이징 설정
	var pageSizeRoom = 5;
	var pageBlockSizeRoom = 5;

	// 장비 페이징 설정
	var pageSizeItem = 5;
	var pageBlockSizeItem = 5;

	/** OnLoad event */
	$(function() {
		//comcombo("rm_seq","rmseq","all","");

		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
	});

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
			case 'btnSaveRoom':
				fSaveRoom();
				alert("저장되었습니다.");
				break;
			case 'btnDeleteRoom':
				$("#action").val("D");
				fSaveRoom();
				alert("삭제되었습니다.");
				console.log("삭제");
				break;
			case 'btnSaveItem':
				fSaveItem();
				alert("저장되었습니다.");
				break;
			case 'btnDeleteItem':
				$("#iaction").val("D");
				fSaveItem();
				alert("삭제되었습니다.");
				break;
			case 'btnSearchRoom':
				searchRoom();
				break;
			case 'btnCloseRoom':
			case 'btnCloseItem':
				gfCloseModal();
				break;
			}
		});
	}
</script>

</head>
<body>
	<form id="myForm" action="" method="">

		<input type="hidden" name="action" id="action" value=""> <input
			type="hidden" name="broom_no" id="broom_no" value=""> <input
			type="hidden" name="iaction" id="iaction" value=""> <input
			type="hidden" name="broom_name" id="broom_name" value=""> <input
			type="hidden" name="bkpagenum" id="bkpagenum" value="">
		<input type="hidden" name="room_seq" id="room_seq" value=""><!-- roomDetail 에서 따온 값을 roomUpdate 할때 써먹을거 -->
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
								<span class="btn_nav bold">시설관리</span> <span
									class="btn_nav bold">강의실 </span> <a href="../adm/Room.do"
									class="btn_set refresh">새로고침</a>
							</p>

							<p class="conTitle">
								<span>강의실</span> <span class="fr"> <select id="stype"
									name="stype" style="width: 150px;">
										<option value="all">전체</option>
										<option value="rmnumber">순번</option>
										<option value="rmname">강의실이름</option>
										<option value="teacher">강사</option>
								</select> 검색어 <input type="text" style="width: 300px; height: 25px;"
									id="sword" name="sword"> <a href=""
									class="btnType blue" id="btnSearchRoom" name="btn"> <span>검
											색</span></a> <a class="btnType blue"
									href="javascript:fn_roomRegPopup();" name="modal"> <span>신규등록</span></a>
								</span>


							</p>

							<div class="roomList">

								<table style="margin-top: 10px" width="100%" cellpadding="5"
									cellspacing="0" border="1" align="left"
									style="collapse; border: 1px #50bcdf;">
									<tr style="border: 0px; border-color: blue">
										<td width="80" height="25" style="font-size: 120%;">&nbsp;&nbsp;</td>
										<td width="50" height="25"
											style="font-size: 100%; text-align: left; padding-right: 25px;">

										</td>

									</tr>
								</table>

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
									</colgroup>

									<thead>
										<tr>
											<th scope="col">순번</th>
											<th scope="col">강의실 이름</th>
											<th scope="col">강의이름</th>
											<th scope="col">자리수</th>
											<th scope="col">강사</th>
											<th scope="col">강의기간</th>
											<th scope="col"></th>

										</tr>
									</thead>
									<tbody id="tbodyRoomList"></tbody>
								</table>
							</div>

							<div class="paging_area" id="roomListPagination"></div>

							<br><br><br>
							
							<div id="divItemList">
							<p class="conTitle">
								<span>장비</span> <span class="fr"> <a class="btnType blue"
									href="javascript:fn_itemPopup();" name="modal"><span>신규등록</span></a>
								</span>
							</p>


								<table class="col">
									<caption>caption</caption>
									<colgroup>
										<col width="10%">
										<col width="70%">
										<col width="10%">
										<col width="10%">
									</colgroup>

									<thead>
										<tr>
											<th scope="col">장비코드</th>
											<th scope="col">장비명</th>
											<th scope="col">수량</th>
											<th scope="col"></th>
										</tr>
									</thead>
									<tbody id="tbodyItemList"></tbody>
								</table>
							<div class="paging_area" id="itemListPagination"></div>
						</div>


						</div> 
						<br><br>



						<h3 class="hidden">풋터 영역</h3> <jsp:include
							page="/WEB-INF/view/common/footer.jsp"></jsp:include>
					</li>
				</ul>
			</div>
		</div>




		<!-- 모달팝업 -->
		<div id="layer1" class="layerPop layerType2" style="width: 600px;">
			<dl>
				<dt>
					<strong>강의실 관리</strong>
				</dt>
				<dd class="content">
					<!-- s : 여기에 내용입력 -->
					<table class="row">
						<caption>caption</caption>
						<colgroup>
							<col width="20%">
							<col width="*">
							<col width="*">
							<col width="*">
							<col width="*">
							<col width="*">
							<col width="*">
						</colgroup>

						<tbody>
							<tr>
								<th scope="row">순번 <span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100" name="room_no"
									id="room_no" /></td>
								<th scope="row">강의실이름 <span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100"
									name="room_name" id="room_name" /></td>
							</tr>
							<tr>
								<th scope="row">자릿수 <span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100"
									name="room_person" id="room_person" /></td>
								<th scope="row">사용유무 <span class="font_red">*</span></th>
								<td colspan="3"><input type="radio" id="radio1-2"
									name="room_status" id="room_status_2" value='N' /> <label
									for="radio1-2">미사용</label> &nbsp;&nbsp;&nbsp;&nbsp; <input
									type="radio" id="radio1-1" name="room_status"
									id="room_status_1" value='Y' /> <label for="radio1-1">사용</label>
								</td>
							</tr>
						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSaveRoom" name="btn"><span>저장</span></a>
						<a href="" class="btnType blue" id="btnDeleteRoom" name="btn"><span>삭제</span></a>
						<a href="" class="btnType gray" id="btnCloseRoom" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>




		<div id="layer2" class="layerPop layerType2" style="width: 600px;">
			<dl>
				<dt>
					<strong>장비 관리</strong>
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
								<th scope="row">강의실코드 <span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100" name="iroom_no"
									id="iroom_no" readonly /></td>
								<th scope="row">강의실 명 <span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100"
									name="iroom_name" id="iroom_name" readonly /></td>
							</tr>
							<tr>
								<th scope="row">장비코드<span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100" id="item_no"
									name="item_no"  readonly/></td>
								<th scope="row">장비명 <span class="font_red">*</span></th>
								<td><input type="text" class="inputTxt p100" id="item_name"
									name="item_name" /></td>
							</tr>

							<tr>
								<th scope="row">수량</th>
								<td><input type="text" class="inputTxt p100"
									id="item_volume" name="item_volume"
									onkeydown="fFilterNumber(event);" /></td>
								<th scope="row">비고</th>
								<td><input type="text" class="inputTxt p100" id="item_note"
									name="item_note" /></td>
							</tr>

						</tbody>
					</table>

					<!-- e : 여기에 내용입력 -->

					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSaveItem" name="btn"><span>저장</span></a>
						<a href="" class="btnType blue" id="btnDeleteItem" name="btn"><span>삭제</span></a>
						<a href="" class="btnType gray" id="btnCloseItem" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>
		<!--// 모달팝업 -->
	</form>
</body>
</html>