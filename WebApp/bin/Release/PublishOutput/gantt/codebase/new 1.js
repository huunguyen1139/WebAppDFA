gantt.plugins({
		marker: true,
		drag_timeline: true
	});
	var holidays = [new Date(2020, 9, 1),new Date(2020, 8, 14)];
	var dateToStr = gantt.date.date_to_str(gantt.config.task_date);
	var today = new Date(2020, 8, 24);
	gantt.addMarker({
		start_date: today,
		css: "today",
		text: "Today",
		title: "Today: " + dateToStr(today)
	});
	
	for (var i = 0; i < holidays.length; i++) {	gantt.setWorkTime({date: holidays[i], hours: false});}
	
	gantt.config.scales = [{unit: 'day', step: 1, format: '%l, %F %d'},{unit: 'hour', step: 1, format: '%H'},];
	
	gantt.config.columns = [
		{name: 'text', tree: true, width: '*'},
		{name: 'start_date', align: 'center'},
		{name: 'duration', label:'Duration', align: 'center', template: function(task) {
			return autoFormatter.format(task.duration);
		}, width: 100}
		
		
	];
	gantt.config.scale_height = 26 * 3;	gantt.config.min_column_width = 18;
	
	gantt.ignore_time = function (date) {if (date.getHours() < 8 || date.getHours() > 15) {return true;}	return false;};
	
	gantt.config.duration_unit = 'minute';gantt.config.work_time = true;gantt.config.time_step = 15;gantt.config.round_dnd_dates = false;
	gantt.config.open_tree_initially = true;

	gantt.setWorkTime({day: 6 }); gantt.setWorkTime({hours: [8, 16]});	

	var dayFormatter = gantt.ext.formatters.durationFormatter({enter: 'day', store: 'minute'
	, format: 'day',hoursPerDay: 8,	hoursPerWeek: 48,daysPerMonth: 30, short: false	});
	
	var hourFormatter = gantt.ext.formatters.durationFormatter({enter: 'hour', store: 'minute', format: 'hour',	short: true	});
	
	var autoFormatter = gantt.ext.formatters.durationFormatter({enter: 'day',store: 'minute', format: 'auto'});
		
		
	gantt.config.lightbox.sections = [
		{name: 'description', height: 70, map_to: 'text', type: 'textarea', focus: true},
		{name: 'time', type: 'duration', map_to: 'auto', formatter: autoFormatter}];

	
	gantt.templates.timeline_cell_class = function (task, date) {if (!gantt.isWorkTime(date)) return 'week_end';return '';	};
	
	gantt.init('gantt_here');

	gantt.parse({
		data: [
{ id: 1, text: '052NHD-7 | 21 - 9', type: 'task', start_date: '18-09-2020 12:00', duration: 45, progress: 1, parent: 0},
{ id: 2, text: '050URB | 23 - 9', type: 'task', start_date: '18-09-2020 12:45', duration: 75, progress: 1, parent: 0},
{ id: 3, text: '051BS | 23 - 9', type: 'task', start_date: '18-09-2020 14:00', duration: 285, progress: 1, parent: 0},
{ id: 4, text: '053NHD-1 | 24 - 9', type: 'task', start_date: '19-09-2020 10:45', duration: 375, progress: 1, parent: 0},
{ id: 5, text: '053NHD-2 | 24 - 9', type: 'task', start_date: '21-09-2020 09:00', duration: 330, progress: 0.5, parent: 0},
{ id: 6, text: '031URB | 28 - 9', type: 'task', start_date: '21-09-2020 14:30', duration: 1065, progress: 0, parent: 0},
{ id: 7, text: '052NHD-9 | 29 - 9', type: 'task', start_date: '24-09-2020 08:15', duration: 330, progress: 0, parent: 0},
{ id: 8, text: '052NHD-10 | 29 - 9', type: 'task', start_date: '24-09-2020 13:45', duration: 180, progress: 0, parent: 0},
{ id: 9, text: '030URB-1 | 29 - 9', type: 'task', start_date: '25-09-2020 08:15', duration: 495, progress: 0, parent: 0},
{ id: 10, text: '030URB-2 | 29 - 9', type: 'task', start_date: '26-09-2020 08:30', duration: 435, progress: 0, parent: 0},
{ id: 11, text: '054GUD | 30 - 9', type: 'task', start_date: '26-09-2020 15:45', duration: 165, progress: 0, parent: 0},
{ id: 12, text: '053NHD-3 | 30 - 9', type: 'task', start_date: '28-09-2020 10:15', duration: 540, progress: 0, parent: 0},
{ id: 13, text: '053NHD-4 | 30 - 9', type: 'task', start_date: '29-09-2020 11:15', duration: 75, progress: 0, parent: 0},
{ id: 14, text: '086NHD | 30 - 9', type: 'task', start_date: '29-09-2020 12:30', duration: 405, progress: 0, parent: 0},
{ id: 15, text: '032URB | 2 - 10', type: 'task', start_date: '30-09-2020 11:15', duration: 690, progress: 0, parent: 0},
{ id: 16, text: '083NHD | 4 - 10', type: 'task', start_date: '01-10-2020 14:30', duration: 660, progress: 0, parent: 0},
{ id: 17, text: '048JT | 6 - 10', type: 'task', start_date: '03-10-2020 09:30', duration: 240, progress: 0, parent: 0},
		],	links: [
		
{id:1,source:1,target:2,type:0},
{id:2,source:2,target:3,type:0},
{id:3,source:3,target:4,type:0},
{id:4,source:4,target:5,type:0},
{id:5,source:5,target:6,type:0},
{id:6,source:6,target:7,type:0},
{id:7,source:7,target:8,type:0},
{id:8,source:8,target:9,type:0},
{id:9,source:9,target:10,type:0},
{id:10,source:10,target:11,type:0},
{id:11,source:11,target:12,type:0},
{id:12,source:12,target:13,type:0},
{id:13,source:13,target:14,type:0},
{id:14,source:14,target:15,type:0},
{id:15,source:15,target:16,type:0},
{id:16,source:16,target:17,type:0}

		]
	});