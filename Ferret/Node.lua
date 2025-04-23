function create_node(x, y, z) return {x = x, y = y, z = z} end

function node_to_string(node)
    return ("%.1f"):format(node.x) .. ', ' .. ("%.1f"):format(node.y) .. ', ' ..
               ("%.1f"):format(node.z)
end
