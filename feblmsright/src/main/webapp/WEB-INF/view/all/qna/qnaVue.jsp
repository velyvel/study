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
	var qnapageSize = 5;
	var qnapageBlockSize = 5;
	
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
				case 'btnSaveqan' :	
					fSaveqan();
					break;
				case 'btnDeleteqna' :
					$("#action").val("D");
					fSaveqan();
					break;
				case 'btnDeleteReply' :
					$("#action").val("D");
					fsavereply();
					break;
				case 'btnSearchqna':
					qnasearchlist();
					break;
				case 'btnCloseGrpCod' :
				case 'btnCloseDtlCod' :
					gfCloseModal();
					break;
				case 'btnCloseqna' :
					gfCloseModal();
				$("#qnadcontent").hide();
				$("#replydata").hide();
				qnasearchlist();
					break;
				case 'replysave' :
					fsavereply();
					break;
			}
		});
	}
	
	
	
</script>

</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" name="qnano" id="qnano" value=""> <!-- qna 디테일 데이터 번호 -->
	<input type="hidden" name="bloginID" id="bloginID" value=""> <!-- 현재 로그인 아이디 -->
	<input type="hidden" name="bname" id="bname" value=""> <!-- 로그인한 이름 -->
	<input type="hidden" name="brplyno" id="brplyno" value=""> <!-- reply 디테일 데이터 번호 -->
	<input type="hidden" name="baction" id="baction" value=""> <!-- reply 에 대한 action값 -->
	
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
								class="btn_nav bold">커뮤니티</span> <span class="btn_nav bold">QnA</span> 
								<a href="../all/qna.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>QnA</span> <span class="fr"> 
		     	                <input type="text" style="width: 300px; height: 25px;" id="qnasearch" name="qnasearch" placeholder="작성자명으로 검색">                    
			                    <a href="" class="btnType blue" id="btnSearchqna" name="btn"><span>검  색</span></a>
			                    <c:if test="${userType eq 'A'}"> <!-- userType이 학생일 때 신규등록 버튼이 보이게끔 -->
							 	   <a	class="btnType blue" href="javascript:qnanewpopup()" id="qna_updqte_data" name="modal"><span>신규등록</span></a>
							    </c:if>
							</span>
						</p>
						
						<div class="qnalist">
							
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="30%">
									<col width="20%">
									<col width="30%">
									<col width="10%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col">글번호</th>
										<th scope="col">글제목</th>
										<th scope="col">등록일</th>
										<th scope="col">작성자</th>
										<th scope="col">조회수</th>
									</tr>
								</thead>
								<tbody id="tbodyqnalistdata"></tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="qnaPagination"> </div>
						
						<br><br><br><br>
						
						<div id="qnadcontent">
						<p>
						<div id="detail_btn">
							<span class="fr"> 
		     	                <a href="javascript:fn_updateBackup()" class="btnType blue" id="qna_updqte_data" name="modal"><span>수정</span></a>
								<a href="" class="btnType blue" id="btnDeleteqna" name="btn"><span>삭제</span></a> 
							</span>
						</div>
						</p>
							<table class="row">
							<caption>caption</caption>
							<colgroup>
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
								<col width="120px">
								<col width="*">
							</colgroup>

								<tr>
									<th scope="row">글번호</th>
									<td colspan="1"><div id="detail_qna_no"></div></td>
									<th scope="row">작성자</th>
									<td colspan="2"><div id="detail_name"></div></td>
									<th scope="row">등록일</th>
									<td colspan="2"><div id="detail_qna_date"></div></td>
								</tr>
								<tr>
									<th scope="row">제목</th>
									<td colspan="5"><div id="detail_qna_title"></div></td>
									<th scope="row">조회수</th>
									<td colspan="2"><div id="detail_qna_count"></div></td>
								</tr>
								<tr>
									<th scope="row">내용</th>
									<td colspan="8"><div id="detail_qna_content"></div></td>
								</tr>
							</table>
						
						<div id="replydata">
							<table class="col">
							<caption>caption</caption>
							<colgroup>
								<col width="20%">
								<col width="40%">
								<col width="25%">
								<col width="15%">
							</colgroup>
								<thead>
									<tr>
										<th scope="col">댓글작성자</th>
										<th scope="col">댓글내용</th>
										<th scope="col">댓글작성일</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
								<tbody id="tbodyreplylistdata"></tbody>
							</table>
						</div>
						<div class="btn_areaC mt30">
						<c:if test="${userType ne 'A'}"> <!-- userType이 학생일 때 답변 버튼이 안보이게. -->
								<a href="javascript:btnaddreply()" class="btnType blue" id="modal" name="modal"><span>답변</span></a>
						</c:if>
								<a href=""	class="btnType gray" id="btnCloseqna" name="btn"><span>취소</span></a>
						</div>
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
				<strong>신규등록</strong>
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
						<col width="120px">
						<col width="*">
						
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">글번호<span class="font_red">*</span></th>
							<td colspan="1"><input type="text" class="inputTxt p100" id="qna_no" name="qna_no" readonly="readonly" placeholder="글번호입니다." /></td>
							<th scope="row">작성자<span class="font_red">*</span></th>
							<td colspan="2"><input type="text" class="inputTxt p100" id="name" name="name" /></div></td>
							<th scope="row">등록일</th>
							<td colspan="1"><input type="text" class="inputTxt p100" id="qna_new_date" name="qna_new_date" readonly="readonly"></input></td>
						</tr>
						<tr>
							<th scope="row">제목<span class="font_red">*</span></th>
							<td colspan="7"><input type="text" class="inputTxt p100" id="qna_new_title" name="qna_new_title" /></td>
						</tr>
						<tr>
							<th scope="row">내용<span class="font_red">*</span></th>
							<td colspan="7"><input colspan="3" type="text" class="inputTxt p100" id="qna_new_content" name="qna_new_content" /></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveqan" name="btn"><span>저장</span></a> 
					<a href=""	class="btnType gray"  id="btnCloseGrpCod" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

	<div id="layer2" class="layerPop layerType2" style="width: 1000px;">
		<dl>
			<dt>
				<strong>QnA답변하기</strong>
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
							<th>댓글번호</th>
							<td colspan="1"><input type="text" class="inputTxt p100" id="reply_no" name="reply_no" readonly="readonly"></input></td>
							<th>댓글작성일</th>
							<td colspan="2"><input type="text" class="inputTxt p100" id="reply_date" name="reply_date" readonly="readonly"></input></td>
							<th>댓글작성자</th>
							<td colspan="2"><input type="text" class="inputTxt p100" id="loginID" name="loginID" readonly="readonly"></input></td>
						</tr>
						<tr>
							<th>댓글내용</th>
							<td colspan="8"><input type="text" class="inputTxt p100" id="reply_content" name="reply_content"></input></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="replysave" name="btn"><span>저장</span></a>
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