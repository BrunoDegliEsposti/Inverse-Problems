function out = isOctave()
    out = exist('OCTAVE_VERSION', 'builtin') ~= 0;
end    