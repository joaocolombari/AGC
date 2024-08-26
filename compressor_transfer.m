% Compressor Transfer Function
function out_db = compressor_transfer(in_db, threshold, ratio)
    out_db = in_db;
    for i = 1:length(in_db)
        if in_db(i) > threshold
            out_db(i) = threshold + (in_db(i) - threshold)/ratio;
        end
    end
end