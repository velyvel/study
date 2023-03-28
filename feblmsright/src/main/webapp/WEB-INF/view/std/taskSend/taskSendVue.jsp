<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>뷰 과제제출</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">

	//  페이징 설정
	var pageSize= 5;
	var pageBlockSize= 5;

	//TODO
	/** 변수 추가 설정, 각 변수는 주석처리하여 정의함 */
	var lectureHeaderArea;
	var lectureListArea;
	var sendListArea;
	var taskContentLayer;
	var taskSendLayer;
	var findId;
	
	
	/** OnLoad event */ 
	$(function() {
		
		selectComCombo("lecbyuser", "lecbyuserall", "all", "");
		init();
		showLectureList();
		
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

	function init(){
		findId = new Vue({
			el: "#findId",
			data :{
				loginId : "${loginId}",
			}
		});

		lectureHeaderArea = new Vue({
			el: "#lectureHeaderArea",
			data : {
				search : "",
			}
		});

		lectureListArea = new Vue({
			el: "#lectureListArea",
			data : {
				lectureItem : [],
				totalCnt : 0,
				currentPage : 0,
				pageSize : 5,
				blockSize : 5,
				pageNav : "",
				loginId : "",
				lectureSeq : "",
				lectureName : ""
			}
		});

		sendListArea  = new Vue({
			el : "#sendListArea",
			data : {
				taskItem : [],
				totalCnt : 0,
				currentPage : 0,
				pageSize : 5,
				blockSize: 5,
				planNo : 0,
				pageNav : "",
			}
		});

		taskContentLayer= new Vue({
			el :"#taskContentLayer",
			data : {
				lectureName : "",
				taskWeek : "",
				taskStart : "",
				taskEnd  : "",
				taskTitle : "",
				taskContent : "",
				fileInfo : "",
			}
		});

		taskSendLayer = new Vue({
			el : "#taskSendLayer",
			data : {
				studentLecture : "",
				studentPlanWeek : "",
				sendTitle : "",
				sendContent : "",
				sendFileName : "",
				taskNo : "",
				action : ""
			}
		});

	}


	//TODO: 리스트 전체 불러오기
	function showLectureList(pageNum){

		$("#sendListArea").hide()
		pageNum = pageNum || 1;

		lectureListArea.currentPage= pageNum;

		var logId = findId.loginId;

		console.log("111+" + logId);

		var param = {
			pageNum : pageNum,
			pageSize : lectureListArea.pageSize,
			lectureSeq : lectureListArea.lectureSeq
		}
		//TODO 로그인 아이디 필요함
		console.log(param);

		var lectureListCallBack = function(lectureListData){
			lectureListArea.currentPage = pageNum;
			//console.log("수강내역 조회 : " + JSON.stringify(lectureListData));

		var paginationHtml = getPaginationHtml(pageNum, lectureListArea.totalcnt, lectureListArea.pageSize, lectureListArea.blockSize, 'showLectureList');
		lectureListArea.lectureListPagination  = paginationHtml;

			lectureListArea.lectureItem = lectureListData.lectureList;
			lectureListArea.totalCnt = lectureListData.totalCnt;

			//console.log(lectureListData);
			//console.log(JSON.stringify(lectureListData));

		};

		callAjax("/std/courseListVue.do", "post", "json", "false", param, lectureListCallBack);
	}


	//TODO: 과제관리 목록 보여주기
	function showSendList(lec_seq,lectureName){

		$("#sendListArea").show()

		taskContentLayer.lectureName = lectureName;
		//console.log(taskContentLayer.lectureName);

		//console.log(taskContentLayer.taskWeek);
		sendListArea.currentPage = sendListArea.currentPage || 1;
		lectureListArea.lectureSeq = lec_seq;

		var param = {
			pageNum : sendListArea.currentPage,
			pageSize : sendListArea.pageSize,
			lectureSeq: lectureListArea.lectureSeq,
			loginId: lectureListArea.loginId,
		}
		//console.log(param);

		var taskListCallBack = function(taskData){
			console.log("과제내역 조회 : " + JSON.stringify(taskData));

			sendListArea.taskItem = taskData.taskList;
			sendListArea.totalCnt = taskData.totalCnt;


		};
		callAjax("/std/taskListVue.do", "post", "json", "false", param, taskListCallBack);
		//TODO 초기화하기: 클릭할 때 마다 다시 조회하기
		sendListArea.tbodySendList = [];
	}

	//TODO 데이터 한건씩 조회하기
	function showTaskDetail(planNo, planWeek){

		sendListArea.planNo = planNo;

		var param = {
			planNo : planNo
		}

		var resultCallBack = function(planNo){
			console.log("과제내용 상세보기" + JSON.stringify(planNo));

			functionInitForm(planNo.taskInfo);
			gfModalPop('#taskContentLayer');
			taskContentLayer.taskWeek = planWeek;
		};
		callAjax("/std/taskContent.do", "post", "json", true, param, resultCallBack)

	}

	function functionInitForm(data){

		var fileName = data.taskName;
		var notFile = "없엉 ㅎㅎㅎㅎㅎㅎ";


		if(fileName == null || fileName == "" || fileName == undefined){
			taskContentLayer.fileinfo = notFile;
		}else{
			taskContentLayer.fileinfo = data.taskName;
		}

		taskContentLayer.taskStart = data.taskStart;
		taskContentLayer.taskEnd = data.taskEnd;
		taskContentLayer.taskTitle = data.taskTitle;
		taskContentLayer.taskContent = data.taskContent;

	}

//TODO 과제제출 상세보기
	function showSendDetail(planNo,taskNo){

		sendListArea.planNo = planNo;


		var lectureSeq = lectureListArea.lectureSeq;
		var loginId = findId.loginId;
		var param = {
			planNo : planNo,
			lectureSeq : lectureSeq,
			taskNo : taskNo
		}

		console.log("로그인 아이디 : " + loginId + " 파라미터 : " + planNo + " 시퀀스:" + lectureSeq + " 과제번호 : " + taskNo );
		//param  값 읽힘

		var detailCallBack = function(lectureSeq){
			console.log("제출내용 상세보기 " + JSON.stringify(lectureSeq));

			functionInitForm2(lectureSeq);
			gfModalPop('#taskSendLayer');
		};
		callAjax("/std/taskSendSelect.do", "post", "json", true, param, detailCallBack)
	}

	//TODO : 버튼 조건값 입력하기
	function functionInitForm2(data2){

		if(data2==null || data2 == "" || data2 == undefined){
			taskSendLayer.action = "I"
		}

		//파이썬만 데이터 있어서 읽힘
		taskSendLayer.studentLecture = data2.lectureNo;
		taskSendLayer.sendTitle = data2.sendTitle;
		taskSendLayer.sendContent = data2.sendContent;
	}
	
		
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<div id="findId">
		<input type="hidden" name="action" id="action" value="">
		<input type="hidden" name="lectureSeq" id="lectureSeq" value="">
		<input type="hidden" name="planNo" id="planNo" value="">
		<input type="hidden" name="lecture" id="lecture" value="">
		<input type="hidden" name="taskNo" id="taskNo" value="">
		<input type="hidden" name="planWeek" id="planWeek" value="">
<%--		<input type="text"  name="loginId" id="loginId" value="${loginId}">--%>
<%--		<input type="text"  name="loginId" id="loginId" value="${loginId}" v-model="loginId">--%>
	</div>
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

						<p class="Location" >
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">학습관리</span> <span class="btn_nav bold">과제제출</span> 
								<a href="../std/taskSend.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle" id="lectureHeaderArea">
							<span>수강 내역</span> <span class="fr"> 
								<select id="lectuerName" name="lectuerName" style="width: 150px;">
								 <option value="name">강의명</option> </select>
							   <input type="text" style="width: 200px; height: 25px; " id="search" name="search" placeholder="검색어를 입력하세요" v-model="search">
			                    <a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
							</span>
						</p>
						
						<div class="lectureList" id="lectureListArea">
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
										<th scope="col">버튼</th>
										
									</tr>
								</thead>
								<template>
									<tbody v-for="(lecture, lectures) in lectureItem">
										<tr>
											<td>{{lecture.lectureSeq}}</td>
											<td v-model="lectureName">{{lecture.lectureName}}</td>
											<td>{{lecture.teacherName}}</td>
											<td>{{lecture.lectureStart}} ~ {{lecture.lectureEnd}}</td>
											<td @click="showSendList(lecture.lectureSeq, lecture.lectureName)"><a class="btnType3 color1">과제관리</a></td>
										</tr>
									</tbody>
								</template>
							 </table>
						   <div class="paging_area" id="lectureListPagination"> </div>
						</div>
						<br>
						<br>
						<div id="sendListArea">
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
<%--								<tbody id="tbodySendList" v-for="taskItem"></tbody>--%>
								<tbody id="tbodySendList" v-for="(task, tasks) in taskItem">
								<tr>
									<td>{{task.plan_week}}</td>
									<td>{{task.plan_goal}}</td>
									<td v-if="task.task_no == 0">등록된 과제가 없네용</td>
									<td v-else @click="showTaskDetail(task.plan_no, task.plan_week)"><a class="btnType3 color1">과제내용</a></td>
									<td v-if="task.task_no == 0">버튼도 없당</td>
									<td v-else @click="showSendDetail(task.plan_no)"><a class="btnType3 color1">제출하기</a></td>
								</tr>
								</tbody>
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
							  <td><div id="lectureName" v-html="lectureName"></div></td>
							<th scope="row">주차 </th>
							  <td><div id="taskWeek" v-html="taskWeek"></div></td>
						</tr>
						<tr>
							<th scope="row">제출일</th>
							   <td><div id="taskStart" v-html="taskStart"></div></td>
							<th scope="row">마감일</th>
							    <td><div id="taskEnd" v-html="taskEnd"></div></td>
						</tr>
						<tr>
							<th scope="row">과제명</th>
							  <td colspan="3"><div id="taskTitle" v-html="taskTitle"></div></td>
						</tr>	  
						<tr style=" height: 150px;">
							<th scope="row">과제 내용</th>
							  <td colspan="3"><div id="taskContent" v-html="taskContent"></div></td>
						</tr>	  
				
						<tr>
							<th scope="row">파일 </th>
							<td colspan="3"><div id="fileinfo" v-html="fileinfo"> </div></td>
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
						<input type="hidden" name="t_taskNo" id="t_taskNo" v-model="taskNo" value=""/>
						<tr>
							<th scope="row">강의명 </th>
							<td><input type="text" class="inputTxt p100" id="s_lecture" name="s_lecture" v-html="studentLecture"readonly/></td>
							<th scope="row">주차</th>
							<td><input type="text" class="inputTxt p100" id="s_planWeek" name="s_planWeek" v-model="studentPlanWeek" readonly/></td>
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt p100" id="sendTitle" name="sendTitle" v-html="sendTitle" /></td>
						</tr>
						<tr>
						<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="3"><textarea  name="sendContent" id="sendContent" style="height: 100px; resize: none;" v-model="sendContent"></textarea></td>
						</tr>	
					    <tr>
							<th scope="row">파일 </th>
							<td colspan="2"><input type="file" class="inputTxt p100"name="selfile" id="selfile" v-model="sendFileName"/>
							<td colspan="2"><div id="fileInfo"> </div></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveTask" name="btn"><span>제출</span></a> 
					<a href="" class="btnType blue" id="btnUpdateTask" @click.prevent="" name="btn"><span>수정</span></a>
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