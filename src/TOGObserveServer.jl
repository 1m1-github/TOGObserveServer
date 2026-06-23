module TOGObserveServer

using ZMQ
using TOGZMQAPIServer
using TOGOctahedron: Octahedron, ∃̇
using TOG: t

const SOCKET = Ref{Socket}()
const TASK = Ref{Task}()

function sleep()
    schedule(TASK[], InterruptException(), error=true)
    TOGZMQAPIServer.sleep(SOCKET[])
end
function awaken(;socketlocation, ω)
    SOCKET[], TASK[] = TOGZMQAPIServer.awaken(socketlocation, Dict(
        :time => time(ω),
        :T => type(ω),
        :type => type(ω),
        :observe, observe(ω),
    ))
end

time(ω) = (x...) -> t(ω)
type(ω) = (x...) -> first(typeof(ω).parameters)

observe(ω) = (x...) -> observe(x..., ω)
observe(o::Octahedron, ω) = ∃̇(o, ω)
# observe(o::Octahedron, ω) = Base.invokelatest(∃̇, o, ω)

end
