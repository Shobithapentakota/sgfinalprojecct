using DiscountPortel.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DiscountPortel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DiscountController : Controller
    {
        public readonly TrainingDBContext trainingDBContext;
        public DiscountController(TrainingDBContext _trainingDBContext)
        {
            trainingDBContext = _trainingDBContext;
        }
        [HttpGet("GetDiscountDetails")]
        public List<Discount> GetDiscountDetails()
        {
            List<Discount> lstDiscount = new List<Discount>();
            try
            {
                lstDiscount = trainingDBContext.Discount.ToList();
                return lstDiscount;
            }
            catch (Exception ex)
            {
                lstDiscount = new List<Discount>();
                return lstDiscount;
            }
        }
        [HttpPost("AddDiscount")]
        public string AddDiscount(Discount discount)
        {
            string message = string.Empty;
            try
            {
                if (!string.IsNullOrEmpty(discount.DiscountName))
                {
                    trainingDBContext.Add(discount);
                    trainingDBContext.SaveChanges();
                    message = "Discount added successfully";
                }
                else
                    message = "Discount Name required.";

            }
            catch (Exception ex)
            {
                message = ex.Message;
            }
            return message;
        }
    }
}
