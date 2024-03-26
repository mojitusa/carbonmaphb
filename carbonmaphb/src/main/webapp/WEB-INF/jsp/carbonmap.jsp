<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script> <!-- OpenLayer 라이브러리 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css"> <!-- OpenLayer css -->

<script type="text/javascript" src="<c:url value='/js/mapTest.js' />"></script> <!-- 지도 맵객체 생성을 위한 js-->
<!-- 지도 크기 설정을 위한 css -->

<script type="text/javascript">
	$( document ).ready(function() {
		
		let cqlFilterSd;
		
		//시도
		var sdLayer = new ol.layer.Tile({
			source : new ol.source.TileWMS({
				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
				params : {
					'VERSION' : '1.1.0', // 2. 버전
					'LAYERS' : 'carbonmap:tl_sd', // 3. 작업공간:레이어 명
					'CQL_FILTER': cqlFilterSd,
					'BBOX' : [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997], 
					'SRS' : 'EPSG:3857', // SRID
					'FORMAT' : 'image/png' // 포맷
				},
				serverType : 'geoserver',
			})
		});
		
		sdLayer.setVisible(false); // 처음에는 레이어를 숨김
		
		//시군구
		var sggLayer = new ol.layer.Tile({
			source : new ol.source.TileWMS({
				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
				params : {
					'VERSION' : '1.1.0', // 2. 버전
					'LAYERS' : 'carbonmap:tl_sgg', // 3. 작업공간:레이어 명
					'BBOX' : [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5], 
					'SRS' : 'EPSG:3857', // SRID
					'FORMAT' : 'image/png' // 포맷
				},
				serverType : 'geoserver',
			})
		});
		
		sggLayer.setVisible(false); // 처음에는 레이어를 숨김
		
		//법정동
		var bjdLayer = new ol.layer.Tile({
			source : new ol.source.TileWMS({
				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
				params : {
					'VERSION' : '1.1.0', // 2. 버전
					'LAYERS' : 'carbonmap:tl_bjd', // 3. 작업공간:레이어 명
					'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
					'SRS' : 'EPSG:3857', // SRID
					'FORMAT' : 'image/png' // 포맷
				},
				serverType : 'geoserver',
			})
		});
		
		bjdLayer.setVisible(false); // 처음에는 레이어를 숨김
		
		let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
		    target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
		    layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
		      new ol.layer.Tile({
		        source: new ol.source.OSM({
		          url: 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png' // vworld의 지도를 가져온다.
		        })
		      }),
		      sdLayer, sggLayer, bjdLayer				
		    ],
		    view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
		      center: ol.proj.fromLonLat([128.4, 35.7]),
		      zoom: 7
		    })
		});
		
		//map.addLayer(peobjeongdong); // 맵 객체에 레이어를 추가함		
		
        
        let sdSelected;
        let sggSelected;
        let bjdSelected;
        $('#sdLayerSelect').change(function() {
        	sdSelected = $(this).val();  // 클릭된 항목의 텍스트 값을 가져옵니다.
        	alert('시도 선택한 값 : ' + sdSelected);
        	console.log('시도 선택한 값 : ' + sdSelected);
 
        	// 텍스트에서 sd_cd의 값을 추출
        	let sd_cd_index = sdSelected.indexOf("sd_cd="); // sd_cd가 시작하는 인덱스
        	let comma_index = sdSelected.indexOf(",", sd_cd_index); // sd_cd 뒤에 오는 첫 번째 쉼표의 인덱스
        	let sd_cd_value = sdSelected.slice(sd_cd_index + 6, comma_index); // sd_cd= 다음에 오는 값을 추출

        	console.log(sd_cd_value); // 결과: 28
        	
        	
        	let sd_nm_index = sdSelected.indexOf("sd_nm="); // sd_nm가 시작하는 인덱스
        	let end_index = sdSelected.indexOf("}", sd_cd_index); // sd_cd 뒤에 오는 }의 인덱스
        	let sdnm = sdSelected.slice(sd_nm_index + 6, end_index); // sd_cd= 다음에 오는 값을 추출
        	
        	console.log('sdnm : ' + sdnm);
        	
            if(sdLayer) {
                map.removeLayer(sdLayer);
             }        	
        	
        	let sdcd = "sd_cd='" + sd_cd_value + "'"; 
        	
        	sdLayer = new ol.layer.Tile({
    			source : new ol.source.TileWMS({
    				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
    				params : {
    					'VERSION' : '1.1.0', // 2. 버전
    					'LAYERS' : 'carbonmap:tl_sd', // 3. 작업공간:레이어 명
    					'CQL_FILTER': sdcd,
    					'BBOX' : [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997], 
    					'SRS' : 'EPSG:3857', // SRID
    					'FORMAT' : 'image/png' // 포맷
    				},
    				serverType : 'geoserver',
    			})
    		}); 
        	map.addLayer(sdLayer);
        	sdLayer.setVisible(true);
            
        	
			// AJAX를 통해 선택한 값을 컨트롤러로 전송
            $.ajax({
                type: 'POST',
                url: '/sdSelect.do',
                data: { selectedValue: sdnm },
                dataType: 'json',
                success: function(response) {
                	alert('시도 전송 성공');
                    console.log(response);
                    
                    var ssgList = response; // 서버에서 받은 ssgList

                    // sggLayerSelect 업데이트
                    var sggLayerSelect  = $('#sggLayerSelect');
                    
                    var sggLayerList = $('#sgglayerList'); 
                    
                    var optionsHTML = ''; // 옵션들을 담을 빈 문자열 생성
                    $.each(ssgList, function(index, item) {
                        
                        console.log(item);
                        
                        // select 요소에 옵션 추가
		                // 띄어쓰기를 기준으로 문자열 분할 후, 마지막 부분 가져오기
		                var sgg = item.sgg_nm.split(' ').pop();
                        console.log(sgg);
                        
                        
		                var option = $('<option></option>').attr('value', item.sgg_cd).text(sgg);
		                sggLayerSelect.append(option); // 새로운 옵션 추가
                        
                        // ul 요소에 리스트 아이템 추가
                        sggLayerList.append($('<li></li>').attr('id', 'sggLayerItem').text(sgg).css('display', 'none'));
                        
                    });
                    
                    
                    console.log(ssgList); // 객체를 콘솔에 출력
                },
                error: function(xhr, status, error) {
                    alert('시도 오류 발생');
                }
            });       	
        	
        });
        
        $('#sggLayerSelect').change(function() {
        	sggSelected = $(this).val();  // 클릭된 항목의 텍스트 값을 가져옵니다.
        	alert('시군구 선택한 값(코드) : ' + sggSelected);
        	console.log('시군구 선택한 값(코드) : ' + sggSelected);
        	
        	let sggcd = "sgg_cd='" + sggSelected + "'";
        	
            if(sggLayer) {
                map.removeLayer(sggLayer);
             }  
        	
    		//시군구
    		sggLayer = new ol.layer.Tile({
    			source : new ol.source.TileWMS({
    				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
    				params : {
    					'VERSION' : '1.1.0', // 2. 버전
    					'LAYERS' : 'carbonmap:tl_sgg', // 3. 작업공간:레이어 명
    					'CQL_FILTER': sggcd,
    					'BBOX' : [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5], 
    					'SRS' : 'EPSG:3857', // SRID
    					'FORMAT' : 'image/png' // 포맷
    				},
    				serverType : 'geoserver',
    			})
    		});        	
        	map.addLayer(sggLayer);
        	sggLayer.setVisible(true);
        	
        	
			// AJAX를 통해 선택한 값을 컨트롤러로 전송
            $.ajax({
                type: 'POST',
                url: '/sggSelect.do',
                data: { sggCode: sggSelected},
                dataType: 'json',
                success: function(response) {
                	alert('시군구 전송 성공');
                	console.log(response);
                    var bjdList = response;

                    // sggLayerSelect 업데이트
                    var bjdLayerSelect  = $('#bjdLayerSelect');
                    
                    var bjdLayerList = $('#bjdlayerList'); 
                    
                    var optionsHTML = ''; // 옵션들을 담을 빈 문자열 생성
                    $.each(bjdList, function(index, item) {
                        
                        console.log("법정동 이름 : " + item.bjd_nm);
                        
                        // select 요소에 옵션 추가
					    // 각 옵션의 HTML 문자열을 생성하여 optionsHTML에 추가
					    optionsHTML += '<option value="' + item.bjd_cd + '">' + item.bjd_nm + '</option>';                        
                        
                        // ul 요소에 리스트 아이템 추가
                        bjdLayerList.append($('<li></li>').attr('id', 'bjdLayerItem').text(item.bjd_nm).css('display' ,'none'));
                        
                    });
                    
                    // 옵션들을 한 번에 추가
                    bjdLayerSelect.html(optionsHTML);                    
                    
                },
                error: function(xhr, status, error) {
                    alert('시군구 오류 발생');
                }
            });
			
        });
        
        $('#bjdLayerSelect').change(function() {
        	
        	bjdSelected = $(this).val();  // 클릭된 항목의 텍스트 값을 가져옵니다.
        	
        	let bjdcd = "bjd_cd='" + bjdSelected + "'";
        	
    		//법정동
    		bjdLayer = new ol.layer.Tile({
    			source : new ol.source.TileWMS({
    				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
    				params : {
    					'VERSION' : '1.1.0', // 2. 버전
    					'LAYERS' : 'carbonmap:tl_bjd', // 3. 작업공간:레이어 명
    					'CQL_FILTER': bjdcd,
    					'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
    					'SRS' : 'EPSG:3857', // SRID
    					'FORMAT' : 'image/png' // 포맷
    				},
    				serverType : 'geoserver',
    			})
    		});
        	map.addLayer(bjdLayer);
        	bjdLayer.setVisible(true);
    		
        });
        
		
	});

</script>
<style> 
    .map-container {
        position: relative;
    }	
	
    .map {
      height: 1030px;
      width: 100%;
    }

    #sdLayerSelect {
        top: 50px; /* 시도 레이어 토글 버튼의 위치 */
        left: 50px;
        position: absolute;
        z-index: 1000; /* 버튼이 최상위에 나타나도록 z-index 설정 */
    }

    #sggLayerSelect {
        top: 80px; /* 시군구 레이어 토글 버튼의 위치 */
        left: 50px;
        position: absolute;
        z-index: 1000; /* 버튼이 최상위에 나타나도록 z-index 설정 */
    }

    #bjdLayerSelect {
        top:110px; /* 법정동 레이어 토글 버튼의 위치 */
        left: 50px; 
        position: absolute;
        z-index: 1000; /* 버튼이 최상위에 나타나도록 z-index 설정 */        
        
    }
  </style>
</head>
<body>
	<div id="map" class="map">
		<!-- 실제 지도가 표출 될 영역 -->
	</div>
	<form id="sdlayerForm">
		<select id="sdLayerSelect" name="sdSelectLayer" >
			<option value="default" selected>시도 선택</option> <!-- 기본값을 설정합니다. -->
            <c:forEach items="${sdList}" var="item">
                <option value="${item}">${item.sd_nm}</option>
            </c:forEach>			
		</select>
		<ul id="sdlayerList">
			<c:forEach items="${sdList }" var="item">
				<li id="sdLayerItem" style="display: none;">${item.sd_nm }</li>
			</c:forEach>
		</ul>
		<input type="hidden" id="sdSelectedLayer" name="sdSelectedLayer">
	</form>

	<form id="sgglayerForm">
		<select id="sggLayerSelect" name="sggSelectLayer" >
			<option value="default" selected>시군구 선택</option> <!-- 기본값을 설정합니다. -->
		</select>
		<ul id="sgglayerList">
		</ul>
		<input type="hidden" id="sggSelectedLayer" name="sggSelectedLayer">
	</form>	
	
	<form id="bjdlayerForm">
		<select id="bjdLayerSelect" name="bjdSelectLayer" >
			<option value="default" selected>법정동 선택</option> <!-- 기본값을 설정합니다. -->
		</select>
		<ul id="bjdlayerList">
		</ul>
		<input type="hidden" id="bjdSSelectedLayer" name="bjdSelectedLayer">
	</form>	
	
	
	
	
</body>
</html>