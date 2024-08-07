library(macpan2)
library(shellpipes)

loadEnvironments()

spec = mp_tmb_model_spec(
before = list(N ~ N
	      , E ~ E0
	      , A ~ A0
	      , R ~ R0
	      , C ~ C0
	      , H ~ H0
	      , I ~ I0
	      , S ~ N - E - A - R - C - H - I
	     )
	, during = c(flow_rates, update_states)
	, default = c(params)
	)

newspec <- mp_tmb_update(spec,
                         default = list(beta = beta, alpha = alpha, omega = omega, theta = theta
                                        , xi = xi, phi = phi, mu = mu, gamma = gamma, sigma = sigma
                                        , N = N, E0 = E0, A0 = A0, R0 = R0, C0 = C0, H0 = H0, I0 = I0)
                        )

## accumulate infections
nspec <- mp_tmb_insert(newspec
                         , expression = list (cases ~ R)
                         , at = Inf
                         , phase = "during"
                        )

## time-varying parameters
beta_changepoints <- c(0, 10, 21, 55, 90)
beta_values <- c(0.005, 1.04, 1.12, 1.15, 1.070)

expr = list(beta ~ time_var(beta_values, beta_changepoints))

## update  model specification with piece-wise transmission rates
timevar_spec <- mp_tmb_insert(nspec
                         , expression = expr
                         , phase = "during"
                         , at = 1L
                         , default = list(beta_values = log(beta_values))
                         , integers = list(beta_changepoints = beta_changepoints)
                        )

rdsSave(timevar_spec)
