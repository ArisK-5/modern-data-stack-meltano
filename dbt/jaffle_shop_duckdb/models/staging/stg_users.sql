with

source as (

    select * from {{ source('faker','users') }}

),

renamed as (

    select
        -- ids
        id as user_id,

        -- strings
        title,
        name as first_name,
        nationality,
        address->>'state' as residence_state,
        occupation,
        academic_degree,
        language as preferred_language,
        email,
        blood_type,
        
        -- numerics
        age,
        gender,
        telephone,
        height as height_meters,
        weight as weight_kgs,

        -- timestamps
        created_at::timestamp as created_at,
        updated_at::timestamp as updated_at

    from source

)

select * from renamed