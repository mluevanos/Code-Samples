using Sabio.Models.Requests.Notes;
using Sabio.Services;
using Sabio.Web.Controllers;
using Sabio.Web.Models.Responses;

namespace Sabio.Web.Api.Controllers
{
    [Route("api/notes")]
    [ApiController]
    public class NoteApiController : BaseApiController
    {
        private INoteService _service = null;
        private IAuthenticationService<int> _authService = null;

        public NoteApiController(INoteService service,
            ILogger<NoteApiController> logger,
            IAuthenticationService<int> authService) : base(logger)
        {
            _service = service;
            _authService = authService;
        }

//Search Notes By Seeker Name (when logged in as provider)
        [HttpGet("bysearchingseeker")]
        public ActionResult<ItemResponse<Paged<Note>>> SearchNotesBySeeker(string searchQuery, int pageIndex, int pageSize)
        {
            int code = 200;
            BaseResponse response = null;

            try
            {
                int userId = _authService.GetCurrentUserId();
                Paged<Note> paged = _service.SearchNotesBySeeker(userId, searchQuery, pageIndex, pageSize);

                    if (paged == null)
                {
                    code = 404;
                    response = new ErrorResponse("Null Response");
                }
                    else
                {
                    response = new ItemResponse<Paged<Note>> { Item = paged };
                }

            }

            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
                base.Logger.LogError(ex.ToString());
            }
            return StatusCode(code, response);
        }

//Search Notes By Provider Name (when logged in as seeker)
        [HttpGet("bysearchingprovider")]
        public ActionResult<ItemResponse<Paged<Note>>> SearchNotesByProvider(string searchQuery, int pageIndex, int pageSize)
        {
            int code = 200;
            BaseResponse response = null;

            try
            {
                int userId = _authService.GetCurrentUserId();
                Paged<Note> paged = _service.SearchNotesByProvider(userId, searchQuery, pageIndex, pageSize);

                if (paged == null)
                {
                    code = 404;
                    response = new ErrorResponse("Null Response");
                }
                else
                {
                    response = new ItemResponse<Paged<Note>> { Item = paged };
                }

            }

            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
                base.Logger.LogError(ex.ToString());
            }
            return StatusCode(code, response);
        }

//GET Notes by Seeker Id (to load on page when logged in as Seeker)
        [HttpGet("seeker")]
        public ActionResult<ItemResponse<Paged<Note>>> GetBySeekerId(int pageIndex, int pageSize)
        {
            int code = 200;
            BaseResponse response = null;

            try
            {
                int userId = _authService.GetCurrentUserId();
                Paged<Note> paged = _service.GetBySeekerId(userId, pageIndex, pageSize);

                if (paged == null)
                {
                    code = 404;
                    response = new ErrorResponse("Null Response");
                }
                else
                {
                    response = new ItemResponse<Paged<Note>> { Item = paged };
                }
            }

            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
                base.Logger.LogError(ex.ToString());
            }
            return StatusCode(code, response);
        }

//GET Note by Id to view or edit individual note
        [HttpGet("{id:int}")]
        public ActionResult<ItemResponse<Note>> Get(int id)
        {
            int iCode = 200;
            BaseResponse response = null;

            try
            {
                Note aNote = _service.Get(id);

                if (aNote == null)
                {
                    iCode = 404;
                    response = new ErrorResponse("Note not found");
                }
                else
                {
                    response = new ItemResponse<Note> { Item = aNote };
                }

            }

            catch (Exception ex)
            {
                iCode = 500;
                base.Logger.LogError(ex.ToString());
                response = new ErrorResponse($"Generic Error: ${ex.Message}");
            }

            return StatusCode(iCode, response);
        }

//GET Notes created by provider Id (to load on page when logged in as Provider)
        [HttpGet("createdby")]
        public ActionResult<ItemResponse<Paged<Note>>> GetNotesCreatedBy(int pageIndex, int pageSize)
        {
            int code = 200;
            BaseResponse response = null;

            try
            {
                int userId = _authService.GetCurrentUserId();
                Paged<Note> paged = _service.GetNotesCreatedBy(userId, pageIndex, pageSize);

                if (paged == null)
                {
                    code = 404;
                    response = new ErrorResponse("Null Response");
                }
                else
                {
                    response = new ItemResponse<Paged<Note>> { Item = paged };
                }
            }

            catch (Exception ex)
            {
                code = 500;
                response = new ErrorResponse(ex.Message);
                base.Logger.LogError(ex.ToString());
            }
            return StatusCode(code, response);
        }

//To populate drop down on form (when writing note as provider)
        [HttpGet("listofseekers")]
        public ActionResult<ItemsResponse<BaseUserProfile>> GetAllSeekerNames()
        {
            int iCode = 200;
            BaseResponse response = null;

            try
            {
                int providerId = _authService.GetCurrentUserId();
                List<BaseUserProfile> search = _service.GetAllSeekerNames(providerId);
                if (search == null)
                {
                    iCode = 404;
                    response = new ErrorResponse("Users Not Found");
                }
                else
                {
                    response = new ItemsResponse<BaseUserProfile> { Items = search };
                }
            }
            catch (Exception ex)
            {
                iCode = 500;
                base.Logger.LogError(ex.ToString());
                response = new ErrorResponse($"Generic Error: ${ex.Message}");
            }
            return StatusCode(iCode, response);
        }

//Adding a new note (for Provider)
        [HttpPost]
        public ActionResult<ItemResponse<int>> Add(AddNoteRequest model)
        {
            int iCode = 201;
            BaseResponse response = null;

            try
            {
                int userId = _authService.GetCurrentUserId();
                int id = _service.Add(model, userId);
                response = new ItemResponse<int> { Item = id };
            }
            catch (Exception ex)
            {
                iCode = 500;
                base.Logger.LogError(ex.ToString());
                response = new ErrorResponse($"Server Error {ex.Message}");
            }
            return StatusCode(iCode, response);
        }

//Updating Note
        [HttpPut("{id:int}")]
        public ActionResult<ItemResponse<int>> Update(UpdateNoteRequest model)
        {
            int iCode = 200;
            BaseResponse response = null;

            try
            {
                int userId = _authService.GetCurrentUserId();
                _service.Update(model, userId);
                response = new SuccessResponse();
            }
            catch (Exception ex)
            {
                iCode = 500;
                base.Logger.LogError(ex.ToString());
                response = new ErrorResponse($"Server Error: {ex.Message}");
            }
            return StatusCode(iCode, response);
        }

//Deleting Note
        [HttpDelete("{id:int}")]
        public ActionResult<SuccessResponse> Delete(int id)
        {
            int iCode = 200;
            BaseResponse response = null;
            try
            {
                _service.Delete(id);
                response = new SuccessResponse();
            }
            catch (Exception ex)
            {
                iCode = 500;
                response = new ErrorResponse(ex.Message);
                base.Logger.LogError(ex.ToString());
            }
            return StatusCode(iCode, response);
        }


    }   
}