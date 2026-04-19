/*************************************************************************************/
// -->Template Name: Bootstrap Press Admin
// -->Author: Themedesigner
// -->Email: niravjoshi87@gmail.com
// -->File: c3_chart_JS
/*************************************************************************************/
$(function() {
    var n = c3.generate({
        bindto: "#column-oriented",
        size: { height: 400 },
        color: { pattern: ["#7460ee", "#009efb", "#f62d51"] },
        data: {
			x: "x",
            columns: [
			["x", "January", "February", "March", "April","May","June"],
                ["WO", 50, 60, 40, 50, 20, 30],
                ["FIT", 220, 130, 240, 90, 130, 200],
                ["PAC", 250, 250, 400, 160, 200, 300]
            ],
			labels: true,
			type: 'spline'
        },
		axis: { x: { type: "category" } },
        grid: { y: { show: !0 } }
    });
});