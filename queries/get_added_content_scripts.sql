select extension_info.downloads, extension_info.extid, extension_info.name, url, crx_most_recent_and_prev.crx_etag as updated_crx
from (
  -- We generate a table containing every crx_etag that we crawled within the
  -- last day and is an update, and a random date where we encountered the its
  -- previous crx_etag. We only use it to find the crx_etag again later.
  select
    crx_first_date1.crx_etag,
    crx_first_date1.extid,
    crx_first_date1.md as most_recent_update,
    max(crx_first_date2.md) as last_date_with_previous_version
  from (
    select crx_etag,extid,min(date) as md
    from extension
    where crx_etag is not null
    group by crx_etag
  ) crx_first_date1
  inner join (
    select extid,min(date) as md
    from extension
    where crx_etag is not null
    group by crx_etag
  ) crx_first_date2
    on crx_first_date1.extid=crx_first_date2.extid
  where
    crx_first_date1.md>crx_first_date2.md
  -- the first time we have seen the crx_etag shall be zero days in the past, rounded to days,
  -- measured from the current date and hour
    and
    TIMESTAMPDIFF(DAY, crx_first_date1.md,  TIMESTAMPADD(HOUR,HOUR(UTC_TIME),UTC_DATE)) = 0
  group by crx_first_date1.crx_etag
) crx_most_recent_and_prev
  inner join content_script_url
    on crx_most_recent_and_prev.crx_etag=content_script_url.crx_etag
  inner join extension extension_info
    on crx_most_recent_and_prev.extid=extension_info.extid
    and extension_info.date=most_recent_update
    and extension_info.crx_etag=crx_most_recent_and_prev.crx_etag
where
  url in (
    "http://*/*",
    "https://*/*",
    "*://*/*",
    "<all_urls>"
  )
and
url not in (
  select url
  from extension natural join content_script_url
  where extid=extension_info.extid and date=last_date_with_previous_version
)
order by extension_info.downloads desc;

