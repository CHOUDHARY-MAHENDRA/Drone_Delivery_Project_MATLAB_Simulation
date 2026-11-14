%% Phase 1: Environment Setup & Verification
clc;
fprintf('=== MATLAB Release ===\n');
disp(matlabRelease);

% 1. Check required & optional toolboxes
requiredTools = { ...
    'Simulink', ...
    'UAV Toolbox', ...
    'Navigation Toolbox', ...
    'Computer Vision Toolbox', ...
    'Image Processing Toolbox', ...
    'Aerospace Blockset', ...
    'Stateflow', ...
    'Simulink 3D Animation', ...
    'Industrial Communication Toolbox', ...
    'Simscape Battery', ...
    'Robotics System Toolbox', ...
    'Control System Toolbox'};

v = ver;
installedNames = {v.Name};
fprintf('\n=== Toolbox Availability ===\n');
for i = 1:numel(requiredTools)
    status = 'MISSING';
    if any(strcmpi(installedNames, requiredTools{i}))
        status = 'INSTALLED';
    end
    fprintf('%-35s : %s\n', requiredTools{i}, status);
end

% 2. Check key functions
fprintf('\n=== Key Function Check ===\n');
funcs = {'uavScenario', 'controllerVFH', 'readAprilTag', 'mavlinkio', 'icomm.mqtt.Client'};
for i = 1:numel(funcs)
    p = which(funcs{i});
    if isempty(p)
        fprintf('%-22s : NOT FOUND\n', funcs{i});
    else
        fprintf('%-22s : OK\n', funcs{i});
    end
end

% 3. Create Project Folder Structure (Linux-compatible)
projRoot = fullfile('/home/mahendra', 'MATLAB_Projects', 'AutonomousDroneDelivery');
if ~isfolder(projRoot)
    mkdir(projRoot);
end
cd(projRoot);

folders = { ...
    'data', ...
    'models', ...
    fullfile('models', 'subsystems'), ...
    'scripts', ...
    'scenarios', ...
    'dashboard', ...
    fullfile('tests', 'unit_tests')};

for k = 1:numel(folders)
    targetDir = fullfile(projRoot, folders{k});
    if ~isfolder(targetDir)
        mkdir(targetDir);
    end
end

% Create MATLAB Project if not already present
prjFile = fullfile(projRoot, 'AutonomousDroneDelivery.prj');
if ~isfile(prjFile)
    proj = matlab.project.createProject('Name', 'AutonomousDroneDelivery', 'Folder', projRoot);
    for k = 1:numel(folders)
        addPath(proj, fullfile(projRoot, folders{k}));
    end
    fprintf('\nCreated MATLAB Project: %s\n', prjFile);
else
    fprintf('\nMATLAB Project already exists: %s\n', prjFile);
end

% 4. Run uavScenario Smoke Test
if ~isempty(which('uavScenario'))
    scene = uavScenario('UpdateRate', 100);
    addMesh(scene, 'polygon', {[-5 -5; 5 -5; 5 5; -5 5], [0 10]}, [0.6 0.6 0.6]);
    show3D(scene);
    title('Phase 1 Verification: uavScenario Smoke Test');
    fprintf('uavScenario Smoke Test: PASSED\n');
else
    fprintf('uavScenario Smoke Test: SKIPPED (UAV Toolbox missing)\n');
end
