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
	var pageSizelecture = 5;
	var pageBlockSizelecture = 10;
	// 강의계획서
	var pageSizePlan = 5;
	var pageBlockSizePlan = 10;
	
	var grpCodList;
	var searchArea;
	var lecturePlan;
	var taskList;
	
	
	/** OnLoad event */ 
	$(function() {
		
		console.log("selectComCombo : "+JSON.stringify(selectComCombo));
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
		
		init();
		
		lectureList();
		
	});
	
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			var btnId = $(this).attr('id');

			switch (btnId) {
				case 'btnSaveTask' :
					fn_insertTask();
					break;
				case 'btnUpdateTask' :
					fn_insertTask();
					break;
				case 'btnSearch':
					lectureList();
					break;
				case 'btnCloseTask' :
					gfCloseModal();
					break;
				case 'btnBack' :
					fn_taskSendInfo();
					break;	
			}
		});
	}
	
	function init(){
		
		grpCodList = new Vue({
			
			el : "#grpCodList",
			data : {
				listitem : [],
				totalcnt : 0,
				cpage : 0,
				pagenavi : ""
			}
			
		});
		
		searchArea = new Vue({
			el : "#search",
			data : {
			all : ""
			}
		});
		
		selectComCombo("lecbyuser", "lecbyuserall", "all", ""); 
		
		lecturePlan = new Vue({
			el : "#lecturePlan",
			data : {
				lecturePlan : false,
				listitem : [],
				totalcnt : 0,
				cpage : 0,
				pagenavi : ""
			}
		});
		
		taskList = new Vue({
			el : "#taskList",
			data : {
				taskList : false,
				taskmodal : false,
				listitem : [],
				totalcnt : 0,
				cpage : 0,
				pagenavi : ""
			}
		});
	}
	
	function lectureList(pageNum){ 
		
		lecturePlan.lecturePlan = false;
		taskList.taskList = false;
		
		pageNum = pageNum || 1;
		
		var param = {
				pageNum : pageNum,
				pageSize : pageSizelecture,
				lecbyuserall : searchArea.all
		}
		
		console.log(param);

		var lectureListCallback = function(listdata){ 
			//console.log("lectureListCallback" + JSON.stringify(listdata));
			
			grpCodList.cpage = pageNum;
			
			grpCodList.listitem = listdata.lectureList;
			grpCodList.totalcnt = listdata.totalCnt;
			
			//console.log("listitem : " + JSON.stringify(grpCodList.listitem));

			var paginationHtml = getPaginationHtml(pageNum, listdata.totalCnt, pageSizelecture, pageBlockSizelecture, 'lectureList');
			
			grpCodList.pagenavi = paginationHtml;

		}; 
		
		callAjax("/tut/vueLecturelist.do", "post", "json", false, param, lectureListCallback);
	}
	
	function planlistsearch(lectureNo, pageNum){
		
		lecturePlan.lecturePlan = true;
		taskList.taskList = false;
		
		pageNum = pageNum || 1;
		
		var param = {
				pageNum : pageNum,
				pageSize : pageSizePlan,
				lectureNo : lectureNo,
		}
		
		var planListCallback = function(plandata){
			
			console.log("planListCallback" + JSON.stringify(plandata));
			
			lecturePlan.cpage = pageNum;
			
			lecturePlan.listitem = plandata.planList;
			lecturePlan.totalcnt = plandata.totalCnt;
			
			var paginationHtml = getPaginationHtml(pageNum, plandata.totalCnt, pageSizePlan, pageBlockSizePlan, 'planlistsearch');
			
			lecturePlan.pagenavi = paginationHtml;
	         
		};
		
		callAjax("/tut/vuePlanlist.do", "post", "json", false, param, planListCallback);
	}
	
	function tasklistsearch(planNo, pageNum){
		
		taskList.taskList = true;
		
		pageNum = pageNum || 1;
		
		var param = {
			pageNum : pageNum,
			pageSize : pageSizelecture,
			planNo : planNo
		}
		
		var taskListCallback = function(listdata){
			
			console.log("taskListCallback : "+JSON.stringify(listdata));
			
			lecturePlan.cpage = pageNum;
			
			taskList.listitem = listdata.taskList;
			taskList.totalcnt = listdata.totalCnt;
			
			 var paginationHtml = getPaginationHtml(pageNum, listdata.totalCnt, pageSizelecture, pageBlockSizelecture, 'tasklistsearch');
			
			 taskList.pagenavi = paginationHtml;
			 
			 if(taskList.totalcnt == 0){
				 taskList.taskmodal = true;
			 }else{
				 taskList.taskmodal = false;
			 }
		};
		
		callAjax("/tut/vueTasklist.do", "post", "json", false, param, taskListCallback);
		
	}
	
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="lectureNo" id="lectureNo" value="">
	<input type="hidden" name="planNo" id="planNo" value="">
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
								class="btn_nav bold">학습관리</span> <span class="btn_nav bold">과제 관리</span> 
								<a href="../tut/task.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle" id="search">
							<span>수업 정보</span> <span class="fr"> 
							   <select id="lecbyuserall" name="lecbyuserall" v-model="all" style="width: 150px;" >
							    </select>                    
			                    <a class="btnType blue" id="btnSearch" name="btn" @click=lectureList()><span>검  색</span></a>
							</span>
						</p>
						
						<div id="grpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="7%">
									<col width="20%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="7%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">강의번호</th>
										<th scope="col">강의명</th>
										<th scope="col">강사명</th>
										<th scope="col">개강일</th>
										<th scope="col">종강일</th>
										<th scope="col">강의실</th>
										<th scope="col">수강인원</th>
									</tr>
								</thead>
								
								<tbody v-for="(item,index) in listitem">
									<tr @click="planlistsearch(item.lectureSeq)">
										<td>{{item.lectureSeq}}</td>
										<td>{{item.lectureName}}</td>
										<td>{{item.tutName}}</td>
										<td>{{item.lectureStart}}</td>
										<td>{{item.lectureEnd}}</td>
										<td>{{item.roomNo}}</td>
										<td>{{item.lecturePerson}}</td>
									</tr>
								</tbody>
							</table>
							<div class="paging_area"  id="lecturelistPagination" v-html="pagenavi"> </div>
						</div>
						<br>
						<br>
						<div id="lecturePlan" v-show="lecturePlan">
							<p class="conTitle">
								<span>강의 계획서</span> <span class="fr"> 
								</span>
							</p>
						
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="13%">
									<col width="30%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">주차</th>
										<th scope="col">학습목표</th>
									</tr>
								</thead>
								<template v-if="totalcnt === 0"> 
									<tbody>
										<tr>
										      <td colspan=3>조회된 데이터가 없습니다.</td>
										 </tr>
									</tbody>
								</template>
								<template v-else>
									<tbody v-for="(item,index) in listitem">
										<tr @click="tasklistsearch(item.planNo)">
										      <td>{{item.planWeek}}</td>
										      <td>{{item.planGoal}}</td>
										 </tr>
									</tbody>
								</template>
							</table>
							<div class="paging_area"  id="planlistPagination" v-html="pagenavi"> </div>
						</div>
						
						<br>
						<br>
						<div id="taskList" v-show="taskList">
							<p class="conTitle">
								<span>과제 관리</span> <span class="fr"> 
								    <a class="btnType blue" href="javascript:fn_taskPopup();" name="modal" id="taskmodal" v-show="taskmodal"><span>과제등록</span></a>
								</span>
							</p>
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="40%">
									<col width="20%">
									<col width="20%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">과제이름</th>
										<th scope="col">제출일</th>
										<th scope="col">마강일</th>
										<th scope="col">제출현황</th>
									</tr>
								</thead>
								<template v-if="totalcnt === 0">
									<tbody>
										<tr>
										      <td colspan=3>조회된 데이터가 없습니다.</td>
										 </tr>
									</tbody>
								</template>
								<template v-else>
									<tbody v-for="(item,index) in listitem">
										<tr>
											<td>{{item.taskTitle}}</td>
											<td>{{item.taskStart}}</td>
											<td>{{item.taskEnd}}</td>
											<td><a class="btnType3 color1" href="javascript:SendInfosearch(item.planNo);"><span>목록 보기</span></a></td>
										</tr>
									</tbody>
								</template>
							</table>
							<div class="paging_area"  id="tasklistPagination" v-html="pagenavi"> </div>
						</div>
						<br>
						<br>
	
					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 과제 등록 & 수정 & 조회 팝업 -->
	<div id="tasklayer1" class="layerPop layerType2" style="width: 500px;">
		<dl>
			<dt>
				<strong>과제 관리</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row" >
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<input type="hidden" class="inputTxt p100" name="iplanNo" id="iplanNo" />
						<tr>
							<th scope="row">제출일 <span class="font_red">*</span></th>
						<td><input type="date" class="inputTxt p100"
								   name="taskStart" id="taskStart" style="font-size: 15px" min/></td>
							<th scope="row">마감일 <span class="font_red">*</span></th>
						<td><input type="date" class="inputTxt p100"
								   name="taskEnd" id="taskEnd" style="font-size: 15px"  /></td>
						</tr>
						<tr>
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td colspan="3"><input type="text" class="inputTxt" name="title" id="title" /></td>
						</tr>
						<tr >
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td colspan="3"><textarea  name="content" id="content" style="height: 100px; resize: none;"></textarea></td>
						</tr>
					
						<tr>
							<th scope="row">파일 </th>
							<td><input type="file" class="inputTxt p100"name="selfile" id="selfile" />
							<td colspan="3"><div id="fileinfo"> </div></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveTask" name="btn"><span>등록</span></a> 
					<a href="" class="btnType blue" id="btnUpdateTask" name="btn"><span>수정</span></a> 
					<a href=""	class="btnType gray"  id="btnCloseTask" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	
	<!-- 과제 제출 명단 팝업-->
	<div id="sendListLayer1" class="layerPop layerType2" style="width: 800px; height: 630px;">
		<dl>
			<dt>
				<strong>제출명단</strong>
			</dt>
			<dd class="content">
				<div id="sendList">
					<p class="conTitle">
						<span>제출 목록</span> 
					</p>
					<table class="col">
						<caption>caption</caption>
							<colgroup>
								<col width="20%">
								<col width="30%">
								<col width="20%">
								</colgroup>
							<thead>
							<tr>
								<th scope="col">학생명</th>
								<th scope="col">과제명</th>
								<th scope="col">제출일</th>
							</tr>
							</thead>
							  <tbody id="tbodySendList">
						 </table>
					   <div class="paging_area"  id="sendlistPagination"> </div>
				 </div>
				 <div class="btn_areaC mt30">
					<a href=""	class="btnType gray"  id="btnCloseTask" name="btn"><span>닫기</span></a>
				 </div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

	<!-- 제출 과제 상세 조회 팝업 -->
	<div id="sendDetailLayer" class="layerPop layerType2" style="width: 800px; height: 630px;">
		<dl>
			<dt>
				<strong>과제 관리</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row"  style="width: 750px; height: 450px;">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<input type="hidden" class="inputTxt p100" name="sendNo" id="sendNo" />
						<tr>
							<th scope="row">학생명</th>
						<td><div id="studentName"></div></td>
							<th scope="row">제출일</th>
						<td><div id="sendDate"></div></td>
						</tr>
						<tr>
							<th scope="row">제목 </th>
							<td colspan="3"><div id="sendTitle"></div></td>
						</tr>
						<tr style=" height: 150px;">
							<th scope="row">내용</th>
							<td colspan="3"><div id="sendContent"></div></td>
						</tr>
					
						<tr>
							<th scope="row">파일 </th>
							<td colspan="3"><div id="fileInfo"> </div></td>
						</tr>
					</tbody>
				</table>

				<div class="btn_areaC mt30">
					<a href=""	class="btnType gray"  id="btnBack" name="btn" ><span>이전</span></a>
					<a href=""	class="btnType gray"  id="btnCloseTask" name="btn" ><span>닫기</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
</form>
</body>
</html>