function fig = rcs_circ_plate_driver()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
% This problem is solved by saving the output as a FIG-file.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.
% 
% NOTE: certain newer features in MATLAB may not have been saved in this
% M-file due to limitations of this format, which has been superseded by
% FIG-files.  Figures which have been annotated using the plot editor tools
% are incompatible with the M-file/MAT-file format, and should be saved as
% FIG-files.

load rcs_circ_plate_driver

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'FileName','C:\RSA\chap2\programs\rcs_circ_plate_driver.m', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[402 203 560 479], ...
	'Tag','Fig1', ...
	'ToolBar','none');
h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'ColorOrder',mat1, ...
	'Position',[53 150 423 303], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4976303317535545 -0.07947019867549665 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.06872037914691943 0.4966887417218544 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-0.1255924170616114 1.086092715231788 9.160254037844386], ...
	'Tag','Axes1Text2');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4976303317535545 1.02317880794702 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','[rcsdb] = rcs_circ_plate(r, freq);', ...
	'ListboxTop',0, ...
	'Position',[376.5 280.5 36 17.25], ...
	'String','Go', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','close all', ...
	'ListboxTop',0, ...
	'Position',[376.5 252 36 17.25], ...
	'String','Quit', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[38.25 36.75 112.5 21.75], ...
	'String','plate''s radius - m', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat2, ...
	'ListboxTop',0, ...
	'Position',[151.5 36.75 45 21], ...
	'Style','edit', ...
	'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat3, ...
	'ListboxTop',0, ...
	'Position',[339 35.25 45 21], ...
	'Style','edit', ...
	'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[225.75 35.25 112.5 21.75], ...
	'String','frequency - Hz', ...
	'Tag','Pushbutton2');
if nargout > 0, fig = h0; end