<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>OpenLayers</title>

<link rel="stylesheet" href="./style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v9.0.0/ol.css">

<script type="text/javascript">
	window.onload = init;
	
	function init() {
		const map = new ol.Map({
			view : new ool.View({
				//지도 중심 좌표
				center : [0, 0],
				//지도 zoom 단계
				zoom : 2
			}),
			
			layers : [
				// 뷰, style 등을 관리하기 위해 설정한다.
				new ol.layer.Tile({
					source : new ol.source.OSM()
				})
			],
			
			//지도를 푝시할 대상의 id
			target : 'map'
		})
	}
</script>
</head>
<body>
	<div id="map" class="map">
		
	</div>
    <script src='./main.js'></script>
	<script src="https://cdn.jsdelivr.net/npm/ol@v9.0.0/dist/ol.js"></script>
</body>
</html>