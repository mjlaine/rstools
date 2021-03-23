function mm=model_matrix(rsres)
%MODEL_MATRIX returns model matrix without the intercept column
mm=rsres.res.x;

