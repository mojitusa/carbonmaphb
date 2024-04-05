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

<!-- Google Charts API 스크립트 추가 -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

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
        let sd_cd_value
        
        let sggList
        let bjdList
        
        let sggs_nm;
        let sggs_cd;
        
        let sdName
        let sggBjdFlag
        let lStyle
        
        $('#sdLayerSelect').change(function() {
        	sdSelected = $(this).val();  // 클릭된 항목의 텍스트 값을 가져옵니다.
        	alert('시도 선택한 값 : ' + sdSelected);
        	console.log('시도 선택한 값 : ' + sdSelected);
        	
        	if (sdSelected == 'default') {
	    	 	// legend 클래스를 안 보이도록 변경
	    	 	legendContainer = document.querySelector('.legend');
	    	    legendContainer.style.display = 'none';
        	}
        	
        	sggBjdFlag = 'sgg';
        	
        	var sggLayerSelect  = $('#sggLayerSelect');
        	var bjdLayerSelect  = $('#bjdLayerSelect');
        	
        	sggLayerSelect.empty();
        	bjdLayerSelect.empty();
        	sggLayerSelect.append($('<option></option>').text('시군구 선택').val(''));
        	bjdLayerSelect.append($('<option></option>').text('법정동 선택').val(''));
        	
        	
 
        	// 텍스트에서 sd_cd의 값을 추출
        	let sd_cd_index = sdSelected.indexOf("sd_cd="); // sd_cd가 시작하는 인덱스
        	let comma_index = sdSelected.indexOf(",", sd_cd_index); // sd_cd 뒤에 오는 첫 번째 쉼표의 인덱스
        	sd_cd_value = sdSelected.slice(sd_cd_index + 6, comma_index); // sd_cd= 다음에 오는 값을 추출

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

        	//범례 업데이트
        	if (sdSelected != 'default')
            fetchLegendInfo('sgg_d2_nb');        	
        	
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

                    //범례 추가
                    let legendSelect = $('#legendSelect');
                    legendSelect.empty();
                    legendSelect.append($('<option></option>').attr('value', 'default').text('범례 선택'));
                    legendSelect.append($('<option></option>').attr('value', 'nb').text('내추럴 브레이크'));
                    legendSelect.append($('<option></option>').attr('value', 'eq').text('등간격'));
                    
                    
                    // sggLayerSelect 업데이트
                    var sggLayerSelect  = $('#sggLayerSelect');
                    
                    var sggLayerList = $('#sgglayerList');
                    
                    // sggLayerSelect 업데이트 전에 비우기
                    sggLayerSelect.empty();
                    sggLayerList.empty();
                    console.log("전체 선택 : " + sdSelected.sd_nm);
                    
                    //sggLayerSelect.append($('<option></option>').text('시군구 선택').val('')); // 기본값 추가
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
        	
        	sggBjdFlag = 'bjd';
        	alert('sggBjdFlag 변경 : ' + sggBjdFlag);
        	
        	
        	
            let params = {
                    'VERSION': '1.1.0',
                    'LAYERS': 'carbonmap:bjd_carbon_d2',
                    'BBOX': [1.386872E7, 3906626.5, 1.4428071E7, 4670269.5],
                    'SRS': 'EPSG:3857',
                    'FORMAT': 'image/png'
                }; 
            
        	if (lStyle == 'bjd_d2_eq') {
        		alert(lStyle);
				params['STYLES'] = lStyle;
				
	        	//범례 업데이트
	        	fetchLegendInfo('bjd_d2_eq');
	        	
        	} else if (lStyle == 'bjd_d2_nb') {
	        	//범례 업데이트
	        	fetchLegendInfo('bjd_d2_nb');
	        	
        	}
        	
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
        		
            	//시군구 코드가 4개여도 나오도록
        		params['CQL_FILTER'] = "sgg_cd LIKE '" + sggs_cd + "%'";
        		alert('params : ' + params['CQL_FILTER']);
        		
        		// 시군구 레이어를 경계로 바꿈
        		sdParams['STYLES'] = 'sgg_d2_ol';
        		
        	}
	        	
            if(sdLayer || sggLayer || bjdLayer) {
            	alert('레이어가 있나요?');
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
    		if (sggSelected == "") {
        		// sdLayer의 소스에 접근하여 파라미터 수정
        		let source = sdLayer.getSource();
        		let params = source.getParams();
        		let style; 
        		if (legendSelected == 'eq') {
        			style = 'sgg_d2_eq'
        		} else if (legendSelected == 'nb') {
        			style = 'sgg_d2_nb'
        		}
        		console.log('sggstyle : ' + style);
        		params.STYLES = style; // 스타일 변경
        		source.updateParams(params); // 변경된 파라미터로 소스 업데이트
        		
    		} else {
    			alert('sggSelected ? ' + sggSelected);
	    		sggLayer = new ol.layer.Tile({
	    			source : new ol.source.TileWMS({
	    				url : 'http://localhost:8080/geoserver/carbonmap/wms?service=WMS', // 1. 레이어 URL
	    				params: params,
	    				serverType : 'geoserver',
	    			})
	    		});        	
	        	map.addLayer(sggLayer);
	        	sggLayer.setVisible(true);
    		}
        	
			// AJAX를 통해 선택한 값을 컨트롤러로 전송
            $.ajax({
                type: 'POST',
                url: '/sggSelect.do',
                data: { sggName: sggSelected},
                dataType: 'json',
                success: function(response) {
                	alert('시군구 전송 성공');
                    bjdList = JSON.parse(response.bjdList);
                    
                    let bjdGeo = response.bjdGeo;
                    
                    if( bjdGeo != null) {
	                    map.getView().fit([bjdGeo.xmin, bjdGeo.ymin, bjdGeo.xmax, bjdGeo.ymax], {duation : 900}); 
                    }
                    
                    // bjdLayerSelect 업데이트
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
        
     	// 팝업 오버레이 생성
        var overlay = new ol.Overlay({
          element: document.getElementById('popup'), // 팝업의 HTML 요소
          positioning: 'bottom-center', // 팝업을 마커 아래 중앙에 위치시킴
          offset: [0, -20], // 팝업을 마커 아래로 조정
          autoPan: true // 팝업이 지도 영역을 벗어날 경우 자동으로 팝업 위치를 조정하여 보여줌
        });
        map.addOverlay(overlay);

        // 팝업 닫기 버튼 요소 가져오기
        var popupCloser = document.getElementById('popup-closer');

        // 클릭 이벤트 리스너 설정
        map.on('singleclick', function(evt) {
          // 클릭한 지점의 좌표를 가져옴
          var coordinate = evt.coordinate;
          
          if (sggBjdFlag == 'sgg') {
              // 해당 좌표에서의 지리적 정보를 가져오는 요청을 서버에 보냄
              var featureRequest = new ol.format.WFS().writeGetFeature({
                srsName: 'EPSG:3857',
                featureNS: 'http://localhost:8080/geoserver/carbonmap',
                featurePrefix: 'carbonmap',
                featureTypes: ['sgg_carbon_d2'],
                outputFormat: 'application/json',
                geometryName: 'geom',
                filter: new ol.format.filter.Intersects('geom', new ol.geom.Point(coordinate))
              });        	  
          
          } else if (sggBjdFlag == 'bjd'){
              // 해당 좌표에서의 지리적 정보를 가져오는 요청을 서버에 보냄
              var featureRequest = new ol.format.WFS().writeGetFeature({
                srsName: 'EPSG:3857',
                featureNS: 'http://localhost:8080/geoserver/carbonmap',
                featurePrefix: 'carbonmap',
                featureTypes: ['bjd_carbon_d2'],
                outputFormat: 'application/json',
                geometryName: 'geom',
                filter: new ol.format.filter.Intersects('geom', new ol.geom.Point(coordinate))
              });        	  
          }

          // 서버에 요청 보내기
          fetch('http://localhost:8080/geoserver/carbonmap/wfs', {
            method: 'POST',
            body: new XMLSerializer().serializeToString(featureRequest)
          })
          .then(function(response) {
        	  let res = response.json();
        	  console.log(res);
            return res;
          })
          .then(function(json) {
            // 가져온 정보에서 단계 구분 값을 추출하여 팝업에 표시
            if (json.features.length > 0) {
              var properties = json.features[0].properties;
              var sgg_pu = properties['sgg_pu']; // 예시: 구분 값의 키가 'sgg_cd'라 가정
              var sgg_cd = properties['adm_sect_c']; 
              var sgg_nm = properties['sgg_nm']; 
              var bjd_pu = properties['bjd_pu'];
              let bjd_nm = properties['bjd_nm'];
              let bjd_cd = properties['bjd_cd'];
              
              // 팝업 내용을 구성
              var popupContent;
              if (sggBjdFlag == 'sgg' && sgg_cd.substring(0,2) == sd_cd_value) {
                popupContent = 
                	'<p>' + sgg_nm + '</p>'
                	+ '<p>전력 사용량 : ' + sgg_pu.toLocaleString() + ' kWh' + '</p>';
                	
	              // 팝업 내용 설정
	              document.getElementById('popup-content').innerHTML = popupContent;
	              
	              // 팝업 위치 설정 및 보이기
	              overlay.setPosition(coordinate);                	
              } else if (sggBjdFlag == 'bjd' && bjd_cd.substring(0,4) == sggs_cd.substring(0,4)) {
                popupContent = 
                	'<p>' + bjd_nm + '</p>'
                	+ '<p>전력 사용량 : ' + bjd_pu.toLocaleString() + ' kWh' + '</p>';
                	
	              // 팝업 내용 설정
	              document.getElementById('popup-content').innerHTML = popupContent;
	              
	              // 팝업 위치 설정 및 보이기
	              overlay.setPosition(coordinate);
              }
              
            } else {
              alert('클릭한 지점에 대한 정보를 찾을 수 없습니다.');
            }
          });
        });

        // 팝업 닫기 버튼에 이벤트 리스너 추가
        popupCloser.onclick = function() {
          overlay.setPosition(undefined); // 팝업을 지도에서 제거
          return false; // 이벤트 전파 방지
        };
        
        // navBtn에 클릭 이벤트 리스너 추가
        document.getElementById("navBtn").addEventListener("click", function() {
            toggleSelectBoxContainer();
        });

        const navBtn = document.getElementById('navBtn');
        const selectBoxContainer = document.getElementById('selectBoxContainer');

   		// navBtn 클릭 시 selectBoxContainer를 숨기거나 보이게 하는 함수
        function toggleSelectBoxContainer() {
            // selectBoxContainer의 display 속성을 토글하여 보이거나 숨기도록 함
            selectBoxContainer.style.display = selectBoxContainer.style.display === 'none' ? 'block' : 'none';
            menuSel.style.display = menuSel.style.display === 'none' ? 'flex' : 'none' ;
            navTop.style.borderBottomLeftRadius = navTop.style.borderBottomLeftRadius === '10px' ? '0' : '10px';
            navTop.style.borderBottomRightRadius = navTop.style.borderBottomRightRadius === '10px' ? '0' : '10px';
            
            // 메뉴 텍스트 변경
            navBtn.textContent = selectBoxContainer.style.display === 'none' ? '⏬  메뉴 열기' : '⏫ 메뉴 닫기';
        }    
        
        let legendSelected = 'nb';
        $('#legendSelect').change(function() {
        	legendSelected = $(this).val();
        	if (sggBjdFlag == 'sgg') {
        		// sdLayer의 소스에 접근하여 파라미터 수정
        		let source = sdLayer.getSource();
        		let params = source.getParams();
        		let style; 
        		if (legendSelected == 'eq') {
        			style = 'sgg_d2_eq'
        		} else if (legendSelected == 'nb') {
        			style = 'sgg_d2_nb'
        		}
        		console.log('sggstyle : ' + style);
        		params.STYLES = style; // 스타일 변경
        		source.updateParams(params); // 변경된 파라미터로 소스 업데이트
        		
        		//범례 재구성
        		fetchLegendInfo(style);
        		
        	} else if (sggBjdFlag == 'bjd') {
        		// sggLayer의 소스에 접근하여 파라미터 수정
        		let source = sggLayer.getSource();
        		let params = source.getParams();
        		let style; 
        		if (legendSelected == 'eq') {
        			style = 'bjd_d2_eq'
        			lStyle = style;
        		} else if (legendSelected == 'nb') {
        			style = 'bjd_d2_nb'
        			lStyle = style;
        		}
        		console.log('bjdstyle : ' + style);
        		params.STYLES = style; // 스타일 변경
        		source.updateParams(params); // 변경된 파라미터로 소스 업데이트
        		
        		//범례 재구성
        		fetchLegendInfo(style);
        		
        	}      	
        	
        });
	});
	
	function fetchLegendInfo(styleName) {
	    // GeoServer의 REST API 엔드포인트 설정
	    const baseUrl = 'http://localhost:8080/geoserver';
	    const styleEndpoint = `${"${baseUrl}"}/rest/styles/${"${styleName}"}.sld`;

	    // Ajax를 사용하여 범례 정보 가져오기
	    $.ajax({
	        url: styleEndpoint,
	        dataType: 'xml',
	        success: function(response) {
	        	
	            // Ajax 요청이 성공했을 때 처리할 코드
	            // 반환된 JSON 데이터에서 범례 정보 추출 및 처리
	            let breakValues = extractRuleNames(response);
	            console.log('Break Values:', breakValues);
	            updateLegend(breakValues);

	            // 여기서 범례 이미지 URL을 사용하여 이미지를 화면에 표시하거나 추가적인 처리를 할 수 있습니다.
	        },
	        error: function(xhr, status, error) {
	            // Ajax 요청이 실패했을 때 처리할 코드
	            console.error('Error:', error);
	        }
	    });
	}
	
	function extractRuleNames(sldXml) {
	    const ruleNames = [];

	    // SLD XML을 jQuery 객체로 변환
	    const $xml = $(sldXml);

	    // 각 분류(Classification) 요소를 찾아 반복
	    $xml.find('sld\\:FeatureTypeStyle > sld\\:Rule').each(function() {
	        const $rule = $(this);

	        // Rule 내의 se:Name 요소의 텍스트 값을 추출하여 배열에 추가
	        const ruleName = $rule.find('sld\\:Name').text().trim();
	        console.log('rule : ' + ruleName);
	        ruleNames.push(ruleName);
	    });

	    return ruleNames;
	}

	function updateLegend(breakValues) {
	    const legendContainer = document.querySelector('.legend');

	    // 먼저 기존의 legend-item 요소를 모두 제거합니다.
	    const legendItems = document.querySelectorAll('.legend-item');
	    legendItems.forEach(item => item.remove());

	    // breakValues 배열을 순회하면서 legend-item을 생성하고 legendContainer에 추가합니다.
	    breakValues.forEach((value, index) => {
	        const legendItem = document.createElement('div');
	        legendItem.classList.add('legend-item');

	        // 값을 "-" 기준으로 분리하여 숫자 부분만 추출합니다.
	        const [start, end] = value.split('-').map(Number);
	        
	        // 숫자를 locale string으로 변환하여 읽기 쉽게 만듭니다.
	        const formattedStart = start.toLocaleString();
	        const formattedEnd = end.toLocaleString();	        
	        
	        // 연결된 문자열을 생성합니다.
	        const stringValue = `${"${formattedStart}"} ~ ${"${formattedEnd}"}`;	        
	        
	        const colorSpan = document.createElement('span');
	        colorSpan.style.backgroundColor = getColor(); // getColor 함수는 각 값에 해당하는 색상을 반환하는 것으로 가정합니다.
			
	        const textNode = document.createTextNode(stringValue);
	        legendItem.appendChild(colorSpan);
	        legendItem.appendChild(textNode);
	        
	        legendContainer.appendChild(legendItem);
	    });
	    
	 	// legend 클래스를 보이도록 변경
	    legendContainer.style.display = 'block';
	}

	let counter = 0; // getColor 함수 외부에서 선언하여 값이 유지되도록 수정
	function getColor() {
	    let color = '#ffffff'; // 기본값으로 흰색을 지정
	
	    // counter 변수를 사용하여 다른 색상을 반환
	    switch (counter) {
	        case 0:
	            color = '#ffffff'; // 흰색
	            break;
	        case 1:
	            color = '#ffbfbf'; // 연한 분홍색
	            break;
	        case 2:
	            color = '#ff8080'; // 분홍색
	            break;
	        case 3:
	            color = '#ff4040'; // 적색
	            break;
	        case 4:
	            color = '#ff0000'; // 빨간색
	            break;
	    }
	
	    // counter 값을 증가시킴
	    counter = (counter + 1) % 5; // 0부터 4까지 반복되도록 설정
	
	    return color;
	}  
	
    // Google Charts API 로드
    google.charts.load('current', {'packages':['corechart']});
    
    // 모달 창 열기
    function openModal() {
      // 모달 창 요소 가져오기
      var modal = document.getElementById('statModal');
      
      // 모달 창 열기
      modal.style.display = "block";

      // 그래프 그리기
      drawChart();
    }

    // 모달 창 닫기
    function closeModal() {
      // 모달 창 요소 가져오기
      var modal = document.getElementById('statModal');
      
      // 모달 창 닫기
      modal.style.display = "none";

      // 차트 파기
      var chartDiv = document.getElementById('chart_div');
      chartDiv.innerHTML = ''; // 차트 요소를 비움
    }

    // 그래프 그리기
    function drawChart() {
    	
      	//DB에서 데이터 가져오기
	    // Ajax를 사용하여 차트에 그릴 정보 가져오기
   		fetch('/sdPu.do', { method: 'POST' }) // POST 요청으로 데이터를 요청합니다.
        .then(response => response.json()) // JSON 형식으로 변환합니다.
        .then(data => {
            // 받은 데이터를 처리합니다.
            console.log('Received data:', data);
            
            var dataTable = new google.visualization.DataTable();
            dataTable.addColumn('string', '지역');
            dataTable.addColumn('number', '전력 사용량');
            
            // 받은 데이터를 DataTable 형식으로 변환합니다.
            data.forEach(item => {
                dataTable.addRow([item.sd_nm, item.sd_pu]);
            });
            
            // 변환된 DataTable을 출력합니다.
            console.log(dataTable);
            
            // 옵션 설정
            var options = {
              title: 'Company Performance',
              //vAxis: {title: 'Year',  titleTextStyle: {color: 'red'}}
            };

            // 그래프 생성
            var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
            chart.draw(dataTable, options);            
            
        })
        .catch(error => {
            console.error('Error fetching data:', error);
        });	    
    
    }

</script>
<style> 
    .map-container {
        position: relative;
    }	
	
    .map {
        height: 930px; 
        width: 100%; 
    }

	#nav {
		position: absolute;
		top: 40px;
		left: 80px;
		width: 302px;
	}
	    
    #navTop {
        background-color: #9FA0C3;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
        z-index: 1000;
        text-align: center; /* 가운데 정렬 */
    }
    
    #navBtn {
    	margin: 10px 0;
    	font-size: 17px;
    	cursor: pointer;
    }
    
    #menuSel {
        background-color: #9FA0C3;
        color: #fff;
        width: 260px;
        padding: 10px 0;
        border: none;
        z-index: 1000;
        text-align: center; /* 가운데 정렬 */
        display: flex;
    	
    }
    
    .navMenu {
        text-align: center; /* 텍스트를 가운데 정렬합니다. */
        cursor: pointer; /* 마우스를 가져다 댔을 때 커서 모양을 변경합니다. */
        flex: 1; /* 각 요소가 동일한 너비를 가지도록 합니다. */    
		margin: 0 5px; /* 여백 */   
		padding: 10px 0;
		box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1); /* 그림자 */  
		border-radius: 5px; /* 모서리를 둥글게 만듦 */
		cursor: pointer;   
    }

	.navMenu:hover {
	    background-color: #A7A8C3; /* 호버시 배경색 */
	}
    

    #selectBoxContainer {
        top: 80px;
        height: 600px;
        width: 260px; 
        z-index: 900;
        border: 1px solid rgba(0, 0, 0, 0.1);
        background-color: rgba(255, 255, 255, 0.9);
        border-bottom-left-radius: 10px;
        border-bottom-right-radius: 10px;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        text-align: center;
    }
    
    #sdLayerSelect {
        top: 150px; /* 시도 레이어 토글 버튼의 위치 */
        left: 120px;
        /* position: absolute; */
        z-index: 1000; /* 버튼이 최상위에 나타나도록 z-index 설정 */
    }

    #sggLayerSelect {
        top: 200px; /* 시군구 레이어 토글 버튼의 위치 */
        left: 50px;
        /* position: absolute; */
        z-index: 1000; /* 버튼이 최상위에 나타나도록 z-index 설정 */
    }

    #bjdLayerSelect {
        top: 250px; /* 법정동 레이어 토글 버튼의 위치 */
        left: 50px; 
        /* position: absolute; */
        z-index: 1000; /* 버튼이 최상위에 나타나도록 z-index 설정 */
        
    }
    
    #legendSelect {
        top: 300px;
        left: 50px; 
        /* position: absolute; */
        z-index: 1000; /* 버튼이 최상위에 나타나도록 z-index 설정 */
        
    }
   
   
  /* ---------------------------------------------------*/  
  /* ---------------------------------------------------*/  
  /* ---------------------------------------------------*/
  
  /* Select 스타일 */
  select {
    appearance: none; /* 기본 UI를 숨김 */
    -webkit-appearance: none; /* Safari 및 Chrome 용 */
    -moz-appearance: none; /* Firefox 용 */
    background-color: #fff; /* 배경색 */
    border: 1px solid #ccc; /* 테두리 */
    padding: 8px; /* 내부 여백 */
    font-size: 16px; /* 폰트 크기 */
    font-family: 'Arial', sans-serif; /* 폰트 설정 */
    color: #333; /* 폰트 색상 */
    border-radius: 5px; /* 모서리를 둥글게 만듦 */
    cursor: pointer; /* 마우스 커서를 포인터로 변경 */
    width: 200px; /* 너비 설정 */
  }

  /* 선택된 옵션의 배경색 및 글자색 */
  option:checked {
    background-color: #007bff; /* 선택된 항목의 배경색 */
    color: #fff; /* 선택된 항목의 글자색 */
  }

  /* 드롭다운 화살표 아이콘 */
  select::after {
    content: '\25BC'; /* 화살표 아이콘 */
    position: absolute;
    top: calc(50% - 0.5em); /* 수직 정렬 */
    right: 10px; /* 오른쪽 여백 */
    font-size: 1.2em; /* 아이콘 크기 */
    pointer-events: none; /* 아이콘 클릭 방지 */
  }

  /* Select 요소가 활성화될 때 스타일 */
  select:focus {
    outline: none; /* 포커스 효과 제거 */
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5); /* 포커스시 테두리 효과 */
  }

  /* 드롭다운 목록의 스타일 */
  select option {
    background-color: #fff; /* 배경색 */
    color: #333; /* 글자색 */
    padding: 8px; /* 내부 여백 */
    font-size: 16px; /* 폰트 크기 */
    border-radius: 5px; /* 모서리를 둥글게 만듦 */
  }

  /* 드롭다운 목록의 호버 효과 */
  select option:hover {
    background-color: #f0f0f0; /* 호버시 배경색 */
  }

  /* 드롭다운 목록이 열릴 때의 애니메이션 */
  select:focus option:checked {
    background-color: #007bff; /* 선택된 항목의 배경색 */
    color: #fff; /* 선택된 항목의 글자색 */
  }    
    
    
  /*  -------------------------------------------------- */
  /*  -------------------------------------------------- */
  /*  -------------------------------------------------- */
  /*  ----------------------팝업 스타일--------------------- */
  /* 폰트 스타일 */
  body {
    font-family: 'Arial', sans-serif; /* 여기에 사용할 원하는 폰트 이름을 넣어주세요 */
  }
  
  /* 팝업 스타일 */
  .popup {
    position: relative;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.3);
    padding: 20px;
    width: 250px; /* 가로폭 조정 */
    font-size: 16px;
    color: #333; /* 폰트 색상 */
    line-height: 1.5; /* 줄간격 조정 */
    font-weight: bold; /* 폰트 굵기 */
  }

  /* 팝업 닫기 버튼 스타일 */
  .popup-closer {
    position: absolute;
    top: 5px;
    right: 5px;
    font-size: 20px; /* X 아이콘 크기 */
    color: #888; /* X 아이콘 색상 */
    text-decoration: none;
    transition: color 0.3s ease;
    font-weight: bold; /* 폰트 굵기 */
    line-height: 1; /* 세로 정렬 */
  }

  .popup-closer:hover {
    color: #555; /* 호버 시 색상 변경 */
  }
  
  
    /* ------------------------------------------------------- */
    /* ------------------------------------------------------- */
    /* ------------------------------------------------------- */
    /* ------------------------------------------------------- */
    /* ------------------- 범례 스타일 -------------------- */
  
	/* 범례 스타일 */
	.legend {
	  background-color: rgba(255, 255, 255, 0.8);
	  border: 1px solid #ccc;
	  border-radius: 5px;
	  padding: 10px;
	  position: absolute;
	  bottom: 20px;
	  right: 20px;
	  z-index: 1000;
	  display: none;
	}
	
	.legend-title {
	  font-weight: bold;
	  margin-bottom: 5px;
	}
	
	.legend-item {
	  margin-bottom: 5px;
	}
	
	.legend-item span {
	  display: inline-block;
	  width: 20px;
	  height: 10px;
	  margin-right: 5px;
	}  
	
	/* --------------------------------------------------- */
	/* --------------------------------------------------- */
	/* --------------------------------------------------- */
	/* --------------------------------------------------- */
	/* -----------------모달 스타일----------------------- */
	
    /* 모달 스타일 */
    .modal {
      display: none; /* 기본적으로 모달은 숨겨져 있음 */
      position: fixed; /* 고정 위치 */
      z-index: 1; /* 최상위 */
      left: 0;
      top: 0;
      width: 100%; /* 전체 너비 */
      height: 100%; /* 전체 높이 */
      overflow: auto; /* 스크롤 가능하도록 */
      background-color: rgba(0,0,0,0.4); /* 반투명 배경 */
    }

    /* 모달 내용 스타일 */
    .modal-content {
      background-color: #fefefe; /* 흰색 배경 */
      margin: 3% auto; /* 중앙 정렬 */
      padding: 20px;
      border: 1px solid #888;
      width: 80%; /* 너비 */
    }

    /* 닫기 버튼 스타일 */
    .close {
      color: #aaa;
      float: right;
      font-size: 28px;
      font-weight: bold;
    }

    /* 닫기 버튼 호버 효과 */
    .close:hover,
    .close:focus {
      color: black;
      text-decoration: none;
      cursor: pointer;
    }	
  </style>
</head>
<body>
	<div id="map" class="map">
		<!-- 실제 지도가 표출 될 영역 -->
	</div>
	
	<!-- 팝업을 나타내는 HTML 요소 -->
	<div id="popup" class="popup">
	  <a href="#" id="popup-closer" class="popup-closer">&times;</a>
	  <div id="popup-content"></div>
	</div>
	<div id="nav">
		<div id="navTop">
			<div id=navBtn>
				⏫ 메뉴 닫기
			</div>
			<div id=menuSel>
				<div class=navMenu>지도</div>
				<div class=navMenu>업로드</div>
				<div class=navMenu onclick="openModal()">통계</div>
			</div>
		</div>
		<div id="navMain">
			<div id="selectBoxContainer">
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
				<form id="legendSelectForm">
					<select id="legendSelect" name="legendSelect" >
						<option value="default" selected>범례 선택</option> <!-- 기본값을 설정합니다. -->
					</select>
				</form>			
			</div>
			<div id="upLoad">
				
			</div>
			<div id="stat">
				<!-- 모달 창 -->
				<div id="statModal" class="modal">
					<!-- 모달 내용 -->
					<div class="modal-content">
						<!-- 닫기 버튼 -->
						<span class="close" onclick="closeModal()" style="position: absolute; top: 10px; right: 10px;">&times;</span>
						<!-- 그래프가 그려질 div -->
						<div id="chart_div" style="width: 100%; height: 800px;"></div>
					</div>
				</div>				
			</div>
		</div>
	</div>
		<!-- 범례 요소 -->
		<div class="legend">
		  <div class="legend-title">전력 사용량 범례 (단위 kWh)</div>
		  
		  <div class="legend-item">
		    <span style="background-color: #ff0000;"></span> 0 - 100
		  </div>
		  <div class="legend-item">
		    <span style="background-color: #ffcc00;"></span> 101 - 200
		  </div>
		  <div class="legend-item">
		    <span style="background-color: #00ff00;"></span> 201 - 300
		  </div>
		</div>	
	
</body>
</html>