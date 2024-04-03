<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        
        let sdnm
        
        let sggList
        
        let sggs_nm;
        let sggs_cd;
        
        let sdName
        
        $('#sdLayerSelect').change(function() {
        	sdSelected = $(this).val();  // 클릭된 항목의 텍스트 값을 가져옵니다.
        	alert('시도 선택한 값 : ' + sdSelected);
        	console.log('시도 선택한 값 : ' + sdSelected);
        	
        	var sggLayerSelect  = $('#sggLayerSelect');
        	var bjdLayerSelect  = $('#bjdLayerSelect');
        	
        	sggLayerSelect.empty();
        	bjdLayerSelect.empty();
        	sggLayerSelect.append($('<option></option>').text('시군구 선택').val(''));
        	bjdLayerSelect.append($('<option></option>').text('법정동 선택').val(''));
        	
        	
 
        	// 텍스트에서 sd_cd의 값을 추출
        	let sd_cd_index = sdSelected.indexOf("sd_cd="); // sd_cd가 시작하는 인덱스
        	let comma_index = sdSelected.indexOf(",", sd_cd_index); // sd_cd 뒤에 오는 첫 번째 쉼표의 인덱스
        	let sd_cd_value = sdSelected.slice(sd_cd_index + 6, comma_index); // sd_cd= 다음에 오는 값을 추출

        	console.log(sd_cd_value); // 결과: 28
        	
        	
        	let sd_nm_index = sdSelected.indexOf("sd_nm="); // sd_nm가 시작하는 인덱스
        	let end_index = sdSelected.indexOf("}", sd_cd_index); // sd_cd 뒤에 오는 }의 인덱스
        	sdnm = sdSelected.slice(sd_nm_index + 6, end_index); // sd_cd= 다음에 오는 값을 추출
        	
        	console.log('sdnm : ' + sdnm);
        	
            if(sdLayer || sggLayer || bjdLayer) {
                map.removeLayer(sdLayer);
                map.removeLayer(sggLayer);
                map.removeLayer(bjdLayer);
             }        	
        	
        	sdName = "sd_nm='" + sdnm + "'";
        	let sdCode = "sd='" + sd_cd_value + "'";
        	
        	sdLayer = new ol.layer.Tile({
    			source : new ol.source.TileWMS({
    				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
    				params : {
    					'VERSION' : '1.1.0', // 2. 버전
    					'LAYERS' : 'carbonmap:sgg_carbon_d2', // 3. 작업공간:레이어 명
    					'CQL_FILTER': sdName,
    					'BBOX' : [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5], 
    					'SRS' : 'EPSG:3857', // SRID
    					'FORMAT' : 'image/png', // 포맷
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
                    
                    sggList = JSON.parse(response.sggList); // 서버에서 받은 sggList
                    let geoSgg = response.sggGeo;
                    console.log("sggList : " + sggList);
                    
                    //zoom
                    map.getView().fit([geoSgg.xmin, geoSgg.ymin, geoSgg.xmax, geoSgg.ymax], {duation : 900});  

                    // sggLayerSelect 업데이트
                    var sggLayerSelect  = $('#sggLayerSelect');
                    
                    var sggLayerList = $('#sgglayerList');
                    
                    // sggLayerSelect 업데이트 전에 비우기
                    sggLayerSelect.empty();
                    sggLayerList.empty();
                    console.log("전체 선택 : " + sdSelected.sd_nm);
                    sggLayerSelect.append($('<option></option>').text('시군구 선택').val('')); // 기본값 추가
                    sggLayerSelect.append($('<option></option>').attr('value', '시도 전체 선택').text('전체 선택'));
                    
                    var optionsHTML = ''; // 옵션들을 담을 빈 문자열 생성
                    $.each(sggList, function(index, item) {
                        
                        // select 요소에 옵션 추가
		                // 띄어쓰기를 기준으로 문자열 분할 후, 마지막 부분 가져오기
		               	let indexOfSpace = item.sgg_nm.indexOf(' ');
						let sgg = indexOfSpace !== -1 ? item.sgg_nm.substring(indexOfSpace + 1) : item.sgg_nm;
                        console.log(sgg);
                        
                        
		                var option = $('<option></option>').attr('value', item.sgg_nm).text(sgg);
		                sggLayerSelect.append(option); // 새로운 옵션 추가
                        
                        // ul 요소에 리스트 아이템 추가
                        sggLayerList.append($('<li></li>').attr('id', 'sggLayerItem').text(sgg).css('display', 'none'));
                        
                    });
                    
                    
                    console.log(sggList); // 객체를 콘솔에 출력
                },
                error: function(xhr, status, error) {
                    alert('시도 오류 발생');
                }
            });       	
        	
        });
        
        $('#sggLayerSelect').change(function() {
        	sggSelected = $(this).val();  // 클릭된 항목의 텍스트 값을 가져옵니다.
        	alert('시군구 선택한 값 : ' + sggSelected);
        	console.log('시군구 선택한 값 : ' + sggSelected);
        	
            let params = {
                    'VERSION': '1.1.0',
                    'LAYERS': 'carbonmap:tl_bjd',
                    'BBOX': [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5],
                    'SRS': 'EPSG:3857',
                    'FORMAT': 'image/png'
                }; 
          	let sdParams = {
					'VERSION' : '1.1.0', // 2. 버전
					'LAYERS' : 'carbonmap:sgg_carbon_d2', // 3. 작업공간:레이어 명
					'BBOX' : [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5], 
					'CQL_FILTER': sdName,
					'SRS' : 'EPSG:3857', // SRID
					'FORMAT' : 'image/png', // 포맷
          	}
        	
        	if (sggSelected == '시도 전체 선택') {
        		console.log("sd_nm='" + sdSelected.sd_nm + "'");
        		params['CQL_FILTER'] = "sd_nm='" + sdnm + "'";
        		
        	} else {
        		
            	sggList.forEach(function(map) {
                    if (map.sgg_nm === sggSelected) {
                    	sggs_cd = map.adm_sect_c;
                    }
                });        		
        		
        		params['CQL_FILTER'] = "sgg_cd LIKE '" + sggs_cd + "%'";
        		alert('params : ' + params['CQL_FILTER']);
        		
        		// 시군구 레이어를 경계로 바꿈
        		sdParams['STYLES'] = 'sgg_d2_ol';
        		
        	}
	        	
            if(sdLayer || sggLayer || bjdLayer) {
                map.removeLayer(sdLayer);
                map.removeLayer(sggLayer);
                map.removeLayer(bjdLayer);
             }  
            
            //시도
            sdLayer = new ol.layer.Tile({
    			source : new ol.source.TileWMS({
    				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
    				params : sdParams,
    				serverType : 'geoserver',
    			})
    		});
        	map.addLayer(sdLayer);
        	
    		//시군구
    		sggLayer = new ol.layer.Tile({
    			source : new ol.source.TileWMS({
    				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
    				params: params,
    				serverType : 'geoserver',
    			})
    		});        	
        	map.addLayer(sggLayer);
        	sggLayer.setVisible(true);
        	
        	
        	
        	
			// AJAX를 통해 선택한 값을 컨트롤러로 전송
            $.ajax({
                type: 'POST',
                url: '/sggSelect.do',
                data: { sggName: sggSelected},
                dataType: 'json',
                success: function(response) {
                	alert('시군구 전송 성공');
                    var bjdList = JSON.parse(response.bjdList);
                    
                    let bjdGeo = response.bjdGeo;
                    
                    if( bjdGeo != null) {
	                    map.getView().fit([bjdGeo.xmin, bjdGeo.ymin, bjdGeo.xmax, bjdGeo.ymax], {duation : 900}); 
                    }
                    
                    // sggLayerSelect 업데이트
                    var bjdLayerSelect  = $('#bjdLayerSelect');
                    
                    var bjdLayerList = $('#bjdlayerList'); 
                    
                    // sggLayerSelect 업데이트 전에 비우기
                    bjdLayerSelect.empty();
                    bjdLayerList.empty();
                    
                    var optionsHTML = ''; // 옵션들을 담을 빈 문자열 생성
                    optionsHTML += '<option>' + '법정동 선택' + '</option>';
                    console.log(sggSelected);
                    optionsHTML += '<option value="' + sggSelected + '">' + '전체 선택' + '</option>';
                    
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
        
        let params;
        $('#bjdLayerSelect').change(function() {
        	
        	bjdSelected = $(this).val();  // 클릭된 항목의 value 값을 가져옵니다.
       		console.log(bjdSelected);
       		console.log(sggSelected);
       		
   			params = {
				'VERSION' : '1.1.0', // 2. 버전
				'LAYERS' : 'carbonmap:tl_bjd', // 3. 작업공간:레이어 명
				'BBOX' : [1.3873946E7, 3906626.5, 1.4428045E7, 4670269.5], 
				'SRS' : 'EPSG:3857', // SRID
				'FORMAT' : 'image/png' // 포맷    
   			};   		
       		
       		if (bjdSelected == sggSelected) {
       			
            	sggList.forEach(function(map) {
                    if (map.sgg_nm === sggSelected) {
                    	sggs_cd = map.sgg_cd;
                    }
                });
            	
            	console.log("시군구 비교해서 뽑아낸 코드 : " + sggs_cd);
            	
            	params['CQL_FILTER'] = "sgg_cd LIKE '" + sggs_cd.substring(0, 4) + "%'";
            	
                if(sggLayer || bjdLayer) {
                    map.removeLayer(sggLayer);
                    map.removeLayer(bjdLayer);
                }
       	     	
       		} else {
       			params['CQL_FILTER'] = "bjd_cd='" + bjdSelected + "'";
       			
                if(sdLayer || bjdLayer) {
                    map.removeLayer(sdLayer);
                    map.removeLayer(bjdLayer);
                }
       		}
        	
    		//법정동
    		bjdLayer = new ol.layer.Tile({
    			source : new ol.source.TileWMS({
    				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
    				params: params,
    				serverType : 'geoserver',
    			})
    		});
        	map.addLayer(bjdLayer);
        	bjdLayer.setVisible(true);
       		
        });
        
    	// 1. 지도 이벤트 리스너 설정
    	map.on('singleclick', function(evt) {
    	    // 2. 클릭한 지점의 좌표를 가져옴
    	    var coordinate = evt.coordinate;
    	    
    	    // 3. 해당 좌표에서의 지리적 정보를 가져오는 요청을 서버에 보냄
    	    var featureRequest = new ol.format.WFS().writeGetFeature({
    	        srsName: 'EPSG:3857',
    	        featureNS: 'http://localhost:8080/geoserver/carbonmap',
    	        featurePrefix: 'carbonmap',
    	        featureTypes: ['sgg_carbon_d2'],
    	        outputFormat: 'application/json',
    	        geometryName: 'geom',
    	        filter: new ol.format.filter.Intersects('geom', new ol.geom.Point(coordinate))
    	    });
    	    
    	    // 서버에 요청 보내기
    	    fetch('http://localhost:8080/geoserver/carbonmap/wfs', {
    	        method: 'POST',
    	        body: new XMLSerializer().serializeToString(featureRequest)
    	    })
    	    .then(function(response) {
    	        return response.json();
    	    })
    	    .then(function(json) {
    	        // 4. 가져온 정보에서 단계 구분 값을 추출하여 사용자에게 표시
    	        if (json.features.length > 0) {
    	            var properties = json.features[0].properties;
    	            var sgg_cd = properties['sgg_pu']; // 예시: 구분 값의 키가 'sgg_cd'라 가정
    	            alert('클릭한 구역의 단계 구분 값: ' + sgg_pu);
    	        } else {
    	            alert('클릭한 지점에 대한 정보를 찾을 수 없습니다.');
    	        }
    	    });
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