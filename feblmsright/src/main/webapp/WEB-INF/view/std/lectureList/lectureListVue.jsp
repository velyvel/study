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

		//TODO
		/** 변수 추가 선언, 각 변수는 주석처리해 정의함*/
				// 강의목록~검색까지 있는 div 정의함. 코드라인:
		var headerArea;
		//테이블, 실제로 리스트 나오는 곳 정의함. 코드라인:
		var lectureListArea;
		//강의 상세보기(모달창)
		var lectureDetailArea;



		/** OnLoad event */
		$(function() {
			comcombo("lecture_no", "lectureName", "all", "");
			//TODO
			// 함수 정의란, new vue
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

		function init(){
			headerArea = new Vue({
				el: "#headerArea",
				data : {
					//lectureName: selectbox id 값
					lectureName : "",
					//검색창 id값
					searchWord : "",
				}
			});

			lectureListArea = new Vue({
				el: "#lectureListArea",
				data : {
					//tr 안에 데이터들
					listItem : [],
					totalCnt : 0,
					currentPage : 0,
					pageSize : 5,
					blockSize : 5,
					pageNav : "",

				},
				method : {

				}

			});

			lectureDetailArea = new Vue({
				el: "#lectureDetailArea",
				data : {
					lectureNameDiv : "",
					teacherNameDiv : "",
					lectureStartDiv : "",
					lectureEndDiv : "",
					lecturePersonDiv : "",
					lectureTotalDiv : "",
					lectureGoalDiv : "",
					roomNameDiv : "",
					lecturePlanDiv : "",
					action : ""
				},
				method : {

				}
			});

			comcombo("lecture_no", "lectureName", "all", "");
		}
		//TODO 리스트 전체 불러오기
		function showLectureList(pagenum){

			pageNum = pagenum || 1;

			var param = {
				pagenum : pageNum,
				pageSize: lectureListArea.pageSize,
				searchKey : headerArea.lectureName,
				searchWord: headerArea.searchWord,
				lectureSeq: lectureListArea.lectureSeq

			}

			var listCallBack = function(listData){

				lectureListArea.currentPage = pageNum;
				console.log("데이터 확인 : " + JSON.stringify(listData));

				lectureListArea.listItem = listData.lectureListSearch;
				lectureListArea.totalCnt = listData.totalcnt;

				//TODO 데이터 없을때 페이지 만들지 않는 로직 추가
				// if(dataValues>5){
				//
				// }

				var paginationHtml = getPaginationHtml(pageNum, lectureListArea.totalcnt, lectureListArea.pageSize, lectureListArea.blockSize, 'showLectureList');

				lectureListArea.pageNav = paginationHtml;

				console.log(lectureListArea.listItem);
				console.log(lectureListArea.totalcnt);
			};

			callAjax("/std/lectureListSearchVue.do", "post" , "json", "false", param, listCallBack);
		}


		//TODO 데이터 한건씩 조회하기
		function showLectureDetail(lectureSeq){
			console.log("강의번호 : " + lectureSeq);
			//gfModalPop("#lectureDetailArea");

			var param = {
				lectureSeq : lectureSeq,
			}

			var resultCallBack = function (lectureSeq) {
				console.log("선택항목 데이터 : " + JSON.stringify(lectureSeq));

				functionInitForm(lectureSeq.lectureInfo);
				gfModalPop("#lectureDetailArea");

			};
			callAjax("/std/lectureSelect.do", "post" , "json", true, param, resultCallBack)
		}

		function functionInitForm(lectureSeq){

			//TODO 데이터 콘솔창에 찍히는데 불러오기 질문
			lectureDetailArea.lectureNameDiv = lectureSeq;

		}

		function studentInsert(){

			console.log( "============신청 데이터 입니다 ======================" + lectureListArea.lectureSeq);

			var action = lectureDetailArea.action;
			var param = {
				action : "I",
			}
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
						<p class="conTitle" id="headerArea">
							<span>강의목록</span> <span class="fr">
							<label for="lectureName">목록보기 :
								<select name="lectureName" id="lectureName" style="width: 150px;">

								</select>
							</label>


								마감인원
		     	                <input type="text" style="width: 300px; height: 25px;" id="searchWord" name="searchWord" v-model="searchWord" onkeyup="showLectureList()">
			                    <a href="" class="btnType blue" id="btnSearchLecture" name="btn"><span>검  색</span></a>
							</span>
						</p>

						<div class="divLectureList" id="lectureListArea">

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
								<%--	TODO 리스트 불러오기							--%>
								<template v-if="totalCnt == 0">
									<tbody>
									<tr>
										<td colspan="7"> 데이터없당 </td>
									</tr>
									</tbody>
								</template>

								<template  v-else>
									<tbody v-for="(item, index) in listItem">
									<tr @click="showLectureDetail(item.lecture_seq)">
										<%--	TODO : JSON으로 불러온 데이터 한세트 : {"lecture_seq":10,"lecture_no":5,"loginID":"teacher","test_no":0,"lecture_name":"C언어","room_name":"1001호","lecture_person":"1","lecture_total":"10","lecture_goal":"ㅁ","lecture_start":"2023-03-20","lecture_end":"2023-03-24","lecture_confirm":"N","teacher_name":"강사","lecture_plan":null,"plan_week":null,"plan_goal":null,"plan_content":null,"cnt":0,"today":null},										--%>
										<td>{{item.teacher_name}}</td>
										<td>{{item.lecture_name}}</td>
										<td>{{item.room_name}}</td>
										<td>{{item.lecture_start}}</td>
										<td>{{item.lecture_end}}</td>
										<td>{{item.lecture_person}}</td>
										<td>{{item.lecture_total}}</td>
									</tr>
									</tbody>
								</template>


							</table>
							<div class="paging_area"  id="lecturePagination" v-html="pageNav"> </div>
						</div>






					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
					<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<div id="lectureDetailArea" class="layerPop layerType2" style="width: 1000px;">
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
						<td><div id="lectureNameDiv" v-model="lectureNameDiv">  </div></td>
						<th scope="row">강사명 </th>
						<td><div id="teacherNameDiv" v-model="teacherNameDiv">  </div></td>
					</tr>
					<tr>
						<th scope="row">강의 시작일 </th>
						<td><div id="lectureStartDiv" v-model="lectureStartDiv">  </div></td>
						<th scope="row">강의 마감일 </th>
						<td><div id="lectureEndDiv" v-model="lectureEndDiv">  </div></td>
					</tr>
					<tr>
						<th scope="row">모집인원 </th>
						<td><div id="lecturePersonDiv" v-model="lecturePersonDiv">  </div></td>
						<th scope="row">마감인원 </th>
						<td><div id="lectureTotalDiv" v-model="lectureTotalDiv">  </div></td>
					</tr>
					<tr>
						<th scope="row">수업목표</th>
						<td><div id="lectureGoalDiv" v-model="lectureGoalDiv">  </div></td>
						<th scope="row">강의실</th>
						<td><div id="roomNameDiv" v-model="roomNameDiv">  </div></td>
					</tr>
					<tr>
						<th scope="row">강의계획</th>
						<td colspan="3"><div id="lecturePlanDiv" v-model="lecturePlanDiv">

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