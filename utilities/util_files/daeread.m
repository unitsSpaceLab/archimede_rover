function TR = daeread(filename)
    % Reads vertices (V) and triangular faces (F) from a .dae COLLADA mesh
    % Supports multiple <input> per <triangles>, extracts only VERTEX indices

    xDoc = xmlread(filename);

    % --- Extract positions ---
    posNode = xDoc.getElementsByTagName('float_array').item(0); 
    posStr = char(posNode.getTextContent);
    posVals = str2double(split(strtrim(posStr)))';
    V = reshape(posVals, 3, [])';  % Nx3 vertices

    % --- Find <triangles> ---
    triNode = xDoc.getElementsByTagName('triangles').item(0);

    % Count how many <input> (stride = number of attributes per vertex)
    inputs = triNode.getElementsByTagName('input');
    stride = inputs.getLength;

    % Find which input corresponds to VERTEX
    vertexOffset = -1;
    for k = 0:stride-1
        semantic = char(inputs.item(k).getAttribute('semantic'));
        if strcmp(semantic, 'VERTEX')
            vertexOffset = str2double(inputs.item(k).getAttribute('offset'));
        end
    end
    if vertexOffset < 0
        error('No VERTEX semantic found in <input>');
    end

    % --- Extract indices ---
    polyNode = triNode.getElementsByTagName('p').item(0);
    idxStr = char(polyNode.getTextContent);
    idxVals = str2double(split(strtrim(idxStr)))';

    % Reshape into rows of "stride" numbers per vertex
    idxVals = reshape(idxVals, stride, [])';

    % Pick only the column for VERTEX indices
    vidx = idxVals(:, vertexOffset+1);

    % Reshape into faces (3 vertices per triangle)
    F = reshape(vidx+1, 3, [])';  % +1 for MATLAB indexing

    TR = triangulation(F,V);
end

