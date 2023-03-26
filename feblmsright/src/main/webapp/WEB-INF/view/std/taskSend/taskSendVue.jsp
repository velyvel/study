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

	//  페이징 설정
	var pageSize= 5;
	var pageBlockSize= 5;
	
	
	
	/** OnLoad event */ 
	$(function() {
		
		selectComCombo("lecbyuser", "lecbyuserall", "all", ""); 
		
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
	});
	

	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
				case 'btnSaveTask' :
					fn_saveTask();
					break;
				case 'btnDeleteGrpCod' :
					fDeleteGrpCod();
					break;
				case 'btnSearch' :
					lectureList();
					break;
				case 'btnDeleteDtlCod' :
					fDeleteDtlCod();
					break;
				case 'btnUpdateTask':
					fn_saveTask();
					break;
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
	<input type="hidden" name="lectureSeq" id="lectureSeq" value="">
	<input type="hidden" name="planNo" id="planNo" value="">
	<input type="hidden" name="lecture" id="lecture" value="">
	<input type="hidden" name="taskNo" id="taskNo" value="">
	<input type="hidden" name="planWeek" id="planWeek" value="">
	
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
								class="btn_nav bold">학습관리</span> <span class="btn_nav bold">과제제출</span> 
								<a href="../std/taskSend.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>수강 내역</span> <span class="fr"> 
								<select id="lectuerName" name="lectuerName" style="width: 150px;">
								 <option value="name">강의명</option> </select>
							   <input type="text" style="width: 200px; height: 25px; " id="search" name="search" placeholder="검색어를 입력하세요">                  
			                    <a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
							</span>
						</p>
						
						<div class="lectureList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="30%">
									<col width="15%">
									<col width="35%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">강의번호</th>
										<th scope="col">강의명</th>
										<th scope="col">강사</th>
										<th scope="col">기간</th>
										<th scope="col"></th>
										
									</tr>
								</thead>
								<tbody id="tbodyLectureList"></tbody>
							 </table>
						   <div class="paging_area"  id="lectureListPagination"> </div>
						</div>
						<br>
						<br>
						<div id="sendList">
						<p class="conTitle">
							<span>과제 관리</span> <span class="fr">                
							</span>
						</p>
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="60%">
									<col width="20%">
									<col width="10%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">주차</th>
										<th scope="col">학습목표</th>
										<th scope="col">과제</th>
										<th scope="col">제출</th>
									</tr>
								</thead>
								<tbody id="tbodySendList"></tbody>
							 </table>
						   <div class="paging_area"  id="sendListPagination"> </div>
						</div>
	
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<div id="taskContentLayer" class="layerPop layerType2" style="width: 800px; height: 630px;">
		<dl>
			<dt>
				<strong>과제 내용</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row" style="width: 750px; height: 450px;">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">강의명</th>
							  <td><div id="lectureName"></div></td>
							<th scope="row">주차 </th>
							  <td><div id="taskWeek"></div></td>
						</tr>
						<tr>
							<th scope="row">제출일</th>
							   <td><div id="taskStart"></div></td>
							<th scope="row">마감일</th>
							    <td><div id="taskEnd"></div></td>
						</tr>
						<tr>
							<th scope="row">과제명</th>
							  <td colspan="3"><div id="taskTitle"></div></td>
						</tr>	  
						<tr style=" height: 150px;">
							<th scope="row">과제 내용</th>
							  <td colspan="3"><div id="taskContent"></div></td>
						</tr>	  
				
						<tr>
							<th scope="row">파일 </th>
							<td colspan="3"><div id="fileinfo"> </div></td>
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

	<!-- 고ㅏ제 제출 모달  -->
	<div id="taskSendLayer" class="layerPop layerType2" style="width:580px">
		<dl>
			<dt>
				<strong>과제 제출</strong>
			</dt>
			<dd class="content">

				<!-- s : 여기에 내용입력 -->

				<table class="row"   style="width:500px">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<input type="hidden" name="t_planNo" id="t_planNo" value=""/>
						<input type="hidden" name="t_taskNo" id="t_taskNo" value=""/>
						<tr>
							<th scope="row">강의명 </th>
							<td><input type="text" class="inputTxt p100" id="s_lecture" name="s_lecture"  readonly/></td>
							<th scope="row">주차</th>
							<td><input type="text" class="inputTxt p100" id="s_planWeek" name="s_planWeek" readonly/></td>
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100" id="sendTitle" name="sendTitle" /></td>
						</tr>
						<tr>
						<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="3"><textarea  name="sendContent" id="sendContent" style="height: 100px; resize: none;"></textarea></td>
						</tr>	
					    <tr>
							<th scope="row">파일 </th>
							<td colspan="2"><input type="file" class="inputTxt p100"name="selfile" id="selfile" />
							<td colspan="2"><div id="fileInfo"> </div></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveTask" name="btn"><span>제출</span></a> 
					<a href="" class="btnType blue" id="btnUpdateTask" name="btn"><span>수정</span></a> 
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