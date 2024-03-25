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
		
		//시도
		var shidoLayer = new ol.layer.Tile({
			source : new ol.source.TileWMS({
				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
				params : {
					'VERSION' : '1.1.0', // 2. 버전
					'LAYERS' : 'carbonmap:tl_sd', // 3. 작업공간:레이어 명
					'BBOX' : [1.3871489341071218E7, 3910407.083927817, 1.4680011171788167E7, 4666488.829376997], 
					'SRS' : 'EPSG:3857', // SRID
					'FORMAT' : 'image/png' // 포맷
				},
				serverType : 'geoserver',
			})
		});
		
		shidoLayer.setVisible(false); // 처음에는 레이어를 숨김
		
		//시군구
		var shigunguLayer = new ol.layer.Tile({
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
		
		shigunguLayer.setVisible(false); // 처음에는 레이어를 숨김
		
		//법정동
		var peobjeongdongLayer = new ol.layer.Tile({
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
		
		peobjeongdongLayer.setVisible(false); // 처음에는 레이어를 숨김
		
		let map = new ol.Map({ // OpenLayer의 맵 객체를 생성한다.
		    target: 'map', // 맵 객체를 연결하기 위한 target으로 <div>의 id값을 지정해준다.
		    layers: [ // 지도에서 사용 할 레이어의 목록을 정희하는 공간이다.
		      new ol.layer.Tile({
		        source: new ol.source.OSM({
		          url: 'https://maps.wikimedia.org/osm-intl/{z}/{x}/{y}.png' // vworld의 지도를 가져온다.
		        })
		      }),
		      shidoLayer,
		      shigunguLayer,
		      peobjeongdongLayer
		    ],
		    view: new ol.View({ // 지도가 보여 줄 중심좌표, 축소, 확대 등을 설정한다. 보통은 줌, 중심좌표를 설정하는 경우가 많다.
		      center: ol.proj.fromLonLat([128.4, 35.7]),
		      zoom: 7
		    })
		});
		
		//map.addLayer(peobjeongdong); // 맵 객체에 레이어를 추가함		
		
        $('#toggleShido').click(function () {
            shidoLayer.setVisible(!shidoLayer.getVisible());
        });

        $('#toggleShigungu').click(function () {
            shigunguLayer.setVisible(!shigunguLayer.getVisible());
        });

        $('#togglePeobjeongdong').click(function () {
            peobjeongdongLayer.setVisible(!peobjeongdongLayer.getVisible());
        });
        
        $('#sdlayerForm').submit(function (event) {
            event.preventDefault(); // 기본 동작인 폼 전송을 막음

            var selectedLayer = $('#sdlayerSelect').val(); // 선택된 레이어 값

            // 여기에 선택된 레이어에 따라 원하는 동작을 수행하는 코드 추가

            // 예를 들어, 선택된 레이어에 따라 특정 기능을 수행하거나 특정 레이어를 표시하는 코드를 추가할 수 있습니다.
        });
        
        
        $('#sdLayerSelect').change(function() {
        	var sdValue = $(this).val();  // 클릭된 항목의 텍스트 값을 가져옵니다.
        	alert('선택한 값 : ' + sdValue);
        	console.log('선택한 값 : ' + sdValue);
        	
			// AJAX를 통해 선택한 값을 컨트롤러로 전송
            $.ajax({
                type: 'POST',
                url: '/sdSelect.do',
                data: { selectedValue: sdValue },
                dataType: 'json',
                success: function(response) {
                    var sggList = response;

                    // sggLayerSelect 업데이트
                    var sggLayerSelect  = $('#sggLayerSelect');
                    
                    var sggLayerList = $('#sgglayerList'); 
                    
                    $.each(sggList, function(index, item) {
                        // select 요소에 옵션 추가
                        console.log(item.sgg_nm);
                        sggLayerSelect.append($('<option></option>').attr('value', item.ssg_nm).text(item.ssg_nm));
                        
                        // ul 요소에 리스트 아이템 추가
                        sggLayerList.append($('<li></li>').attr('id', 'sggLayerItem').text(item.ssg_nm));
                        
                    });
                    
                    console.log(sggList); // 객체를 콘솔에 출력
                },
                error: function(xhr, status, error) {
                    alert('오류 발생');
                }
            });       	
        	
        });
        
        $('#sggLayerSelect').change(function() {
        	var sggValue = $(this).val();  // 클릭된 항목의 텍스트 값을 가져옵니다.
        	alert('시군구 선택한 값 : ' + sggValue);
        	console.log('시군구 선택한 값 : ' + sggValue);
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
    
    .toggle-button {
        position: absolute;
        z-index: 1000; /* 버튼이 최상위에 나타나도록 z-index 설정 */
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

    #togglePeobjeongdong {
        top:110px; /* 법정동 레이어 토글 버튼의 위치 */
        left: 50px; 
    }
  </style>
</head>
<body>
	<div id="map" class="map">
		<!-- 실제 지도가 표출 될 영역 -->
	</div>
	<form id="sdlayerForm">
		<select id="sdLayerSelect" name="sdSelectLayer" >
            <c:forEach items="${sdList}" var="item">
                <option value="${item.sd_nm}">${item.sd_nm}</option>
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
		</select>
		<ul id="sgglayerList">
		</ul>
		<input type="hidden" id="sggSelectedLayer" name="sggSelectedLayer">
	</form>	
	
	
	<button id="toggleShido" class="toggle-button">시도 레이어 토글</button>
	<button id="toggleShigungu" class="toggle-button">시군구 레이어 토글</button>
	<button id="togglePeobjeongdong" class="toggle-button">법정동 레이어 토글</button>
	
	
	
</body>
</html>