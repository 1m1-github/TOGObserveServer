module TOGObserveServer

using ZMQ
using TOGZMQAPIServer
using TOGOctahedron: Octahedron
using TOG: t, ∩, 𝕋

const SOCKET = Ref{Socket}()
const TASK = Ref{Task}()

function sleep()
    schedule(TASK[], InterruptException(), error=true)
    TOGZMQAPIServer.sleep(SOCKET[])
end
function awaken(;socketlocation, ω)
    SOCKET[], TASK[] = TOGZMQAPIServer.awaken(socketlocation=socketlocation, functions=Dict(
        :time => time(ω),
        :T => type(ω),
        :type => type(ω),
        :∩ => ∩(ω),
    ))
end

time(ω::𝕋) = (x...) -> t(ω)
type(ω::𝕋) = (x...) -> first(typeof(ω).parameters)
Base.:∩(ω::𝕋) = (x...) -> ∩(x..., ω)

end
