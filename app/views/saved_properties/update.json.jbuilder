json.response render(partial: "shared/flashes", formats: [:html], locals: {notice: "Updated your comment about #{@saved_property.property.address}"})
