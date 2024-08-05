RLSFilterSystemIDCompilerExampleApp;
compilerDir = fullfile(tempdir,'compilerDir'); % Name of temporary directory
if ~exist(compilerDir,'dir')
    mkdir(compilerDir); % Create temporary directory
end
curDir = cd(compilerDir);
copyfile(which('RLSFilterSystemIDCompilerExampleApp'));
copyfile(which('HelperRLSFilterSystemIdentificationSim'));
copyfile(which('HelperCreateParamTuningUI'));
copyfile(which('HelperUnpackUIData'));

mcc('-mN', 'RLSFilterSystemIDCompilerExampleApp', ...
    '-p', fullfile(matlabroot,'toolbox','dsp'));

if ismac
    status = system(fullfile('RLSFilterSystemIDCompilerExampleApp.app', ...
        'Contents', 'MacOS', 'RLSFilterSystemIDCompilerExampleApp'));
else
    status = system(fullfile(pwd, 'RLSFilterSystemIDCompilerExampleApp'));
end

cd(curDir);
rmdir(compilerDir,'s');
